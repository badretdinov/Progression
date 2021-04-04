//
//  PMigrationManager.swift
//  Progression
//
//  Created by Oleg Badretdinov on 20.02.2021.
//

import Foundation
import CoreData

public class PMigrationManager<T: PDatabaseVersion> {
    public init() {}
    
    public func migrateStoreIfNeeded(storeURL: URL, bundle: Bundle) throws {
        try self.migrate(storeURL: storeURL, toVersion: .last, bundle: bundle)
    }
    
    public func migrate(storeURL: URL, toVersion version: T, bundle: Bundle) throws {
        let fileManager = FileManager()
        
        guard fileManager.fileExists(atPath: storeURL.path) else { return }
        
        var currentURL = storeURL
        
        let migrationSteps = try self.migrationSteps(storeURL: storeURL, toVersion: version, bundle: bundle)
        guard !migrationSteps.isEmpty else { return }
        
        var tempDirs = Set<URL>()
        
        try self.forceWALCheckpointingForStore(at: currentURL, bundle: bundle)
        for step in migrationSteps {
            do {
                try autoreleasepool {
                    let manager = NSMigrationManager(sourceModel: step.sourceModel, destinationModel: step.destinationModel)
                    let tempDir = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                    try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true, attributes: nil)
                    let destinationURL = tempDir.appendingPathComponent("Model.sqlite")
                    try manager.migrateStore(from: currentURL, sourceType: NSSQLiteStoreType, options: nil, with: step.mappingModel, toDestinationURL: destinationURL, destinationType: NSSQLiteStoreType, destinationOptions: nil)
                    
                    tempDirs.insert(tempDir)
                    
                    currentURL = destinationURL
                }
            } catch let error {
                throw PMigrationError.couldNotMigrate(from: step.sourceModel, to: step.destinationModel, error: error)
            }
        }
        
        if currentURL != storeURL {
            try NSPersistentStoreCoordinator.replaceStore(at: storeURL, withStoreAt: currentURL)
        }
        
        tempDirs.forEach({ try? fileManager.removeItem(at: $0) })
    }
}

private extension PMigrationManager {
    func migrationSteps(storeURL: URL, toVersion destination: T, bundle: Bundle) throws -> [PMigrationStep<T>] {
        let metadata = try NSPersistentStoreCoordinator.metadata(at: storeURL)
        guard let source = try T.compatibleVersionForStoreMetadata(metadata, bundle: bundle) else {
            throw PMigrationError.unknownDatabaseVersionFound
        }
        
        return try self.migrationSteps(from: source, to: destination, bundle: bundle)
    }
    
    func requiresMigration(at storeURL: URL, toVersion version: T, bundle: Bundle) throws -> Bool {
        let metadata = try NSPersistentStoreCoordinator.metadata(at: storeURL)
        
        return (try T.compatibleVersionForStoreMetadata(metadata, bundle: bundle) != version)
    }
    
    func migrationSteps(from source: T, to destionation: T, bundle: Bundle) throws -> [PMigrationStep<T>] {
        let versions = T.allCases
        guard source != destionation, var sIndex = versions.firstIndex(of: source) else { return [] }
        
        guard let dIndex = versions.firstIndex(of: destionation), dIndex >= sIndex else {
            throw PMigrationError.destionationVersionIsUnreachable
        }
        
        var sourceVersion = source
        var migrationSteps = [PMigrationStep<T>]()
        
        while sourceVersion != destionation {
            let dIndex = versions.index(sIndex, offsetBy: 1)
            let destinationVersion = versions[dIndex]
            
            let step = try PMigrationStep<T>(sourceVersion: sourceVersion, destinationVersion: destinationVersion, bundle: bundle)
            
            migrationSteps.append(step)
            
            sIndex = dIndex
            sourceVersion = destinationVersion
        }

        return migrationSteps
    }
    
    func forceWALCheckpointingForStore(at storeURL: URL, bundle: Bundle) throws {
        let metadata = try NSPersistentStoreCoordinator.metadata(at: storeURL)
        guard let version = try T.compatibleVersionForStoreMetadata(metadata, bundle: bundle) else {
            throw PMigrationError.unknownDatabaseVersionFound
        }
        
        let currentModel = try NSManagedObjectModel.managedObjectModel(forDBVersion: version, bundle: bundle)
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: currentModel)
        
        do {
            let options = [NSSQLitePragmasOption: ["journal_mode": "DELETE"], NSMigratePersistentStoresAutomaticallyOption : false, NSInferMappingModelAutomaticallyOption : false] as [String : Any]
            let store = try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
            try persistentStoreCoordinator.remove(store)
        } catch let error {
            throw PMigrationError.walCheckpointFailed(error)
        }
    }
}
