//
//  PMigrationStep.swift
//  Progression
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import Foundation
import CoreData

internal class PMigrationStep<T: PDatabaseVersion> {
    let sourceModel: NSManagedObjectModel
    let destinationModel: NSManagedObjectModel
    let mappingModel: NSMappingModel
    
    init(sourceVersion: T, destinationVersion: T, bundle: Bundle) throws {
        self.sourceModel = try .managedObjectModel(forDBVersion: sourceVersion, bundle: bundle)
        self.destinationModel = try .managedObjectModel(forDBVersion: destinationVersion, bundle: bundle)
        
        guard let model = Self.mappingModel(from: self.sourceModel, to: self.destinationModel, types: destinationVersion.migrationTypes, bundle: bundle) else {
            throw PMigrationError.couldNotFindMappingModel(from: self.sourceModel, to: self.destinationModel)
        }
        
        self.mappingModel = model
    }
}

private extension PMigrationStep {
    static func mappingModel(from sourceModel: NSManagedObjectModel, to destinationModel: NSManagedObjectModel, types: [PDatabaseMigrationType], bundle: Bundle) -> NSMappingModel? {
        for type in types {
            if let model = self.mappingModel(from: sourceModel, to: destinationModel, type: type, bundle: bundle) {
                return model
            }
        }
        
        return nil
    }
    
    static func mappingModel(from sourceModel: NSManagedObjectModel, to destinationModel: NSManagedObjectModel, type: PDatabaseMigrationType, bundle: Bundle) -> NSMappingModel? {
        switch type {
        case .automatic:
            return self.automaticMappingModel(from: sourceModel, to: destinationModel, bundle: bundle)
        case .named(let modelName):
            return self.namedMappingModel(name: modelName, bundle: bundle)
        case .inferred:
            return self.inferredMappingModel(from: sourceModel, to: destinationModel, bundle: bundle)
        }
    }
    
    static func automaticMappingModel(from sourceModel: NSManagedObjectModel, to destinationModel: NSManagedObjectModel, bundle: Bundle) -> NSMappingModel? {
        return NSMappingModel(from: [bundle], forSourceModel: sourceModel, destinationModel: destinationModel)
    }
    
    static func namedMappingModel(name: String, bundle: Bundle) -> NSMappingModel? {
        guard let url = bundle.url(forResource: name, withExtension: "cdm") else { return nil }
        return NSMappingModel(contentsOf: url)
    }
    
    static func inferredMappingModel(from sourceModel: NSManagedObjectModel, to destinationModel: NSManagedObjectModel, bundle: Bundle) -> NSMappingModel? {
        return try? .inferredMappingModel(forSourceModel: sourceModel, destinationModel: destinationModel)
    }
}
