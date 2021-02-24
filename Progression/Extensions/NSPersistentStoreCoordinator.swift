//
//  NSPersistentStoreCoordinator.swift
//  Progression
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import CoreData

internal extension NSPersistentStoreCoordinator {
    static func metadata(at storeURL: URL) throws -> [String : Any]  {
        do {
            return try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil)
        } catch let error {
            throw PMigrationError.couldNotFetchMetadata(error)
        }
    }
    
    func addPersistentStore(at storeURL: URL, options: [AnyHashable : Any]) throws -> NSPersistentStore {
        do {
            return try addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch let error {
            throw PMigrationError.couldNotAddPersistentStore(error)
        }
    }
    
    static func replaceStore(at targetURL: URL, withStoreAt sourceURL: URL) throws {
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.replacePersistentStore(at: targetURL, destinationOptions: nil, withPersistentStoreFrom: sourceURL, sourceOptions: nil, ofType: NSSQLiteStoreType)
        } catch let error {
            throw PMigrationError.couldNotReplaceStore(error)
        }
    }
}
