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
        self.mappingModel = Self.customMappingModel(fromSourceModel: self.sourceModel, toDestinationModel: self.destinationModel, bundle: bundle)!
    }
}

extension PMigrationStep {
    private static func customMappingModel(fromSourceModel sourceModel: NSManagedObjectModel, toDestinationModel destinationModel: NSManagedObjectModel, bundle: Bundle) -> NSMappingModel? {
        return NSMappingModel(from: [bundle], forSourceModel: sourceModel, destinationModel: destinationModel)
    }
}
