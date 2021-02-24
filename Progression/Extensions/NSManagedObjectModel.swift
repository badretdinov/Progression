//
//  NSManagedObjectModel.swift
//  Progression
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import Foundation
import CoreData

internal extension NSManagedObjectModel {
    static func managedObjectModel<T: PDatabaseVersion>(forDBVersion db: T, bundle: Bundle) throws -> NSManagedObjectModel {
        guard bundle.path(forResource: T.databaseName, ofType: "momd") != nil else {
            throw PMigrationError.couldNotFindDatabase
        }
        
        let subdirectory = "\(T.databaseName).momd"
        let optimizedMpdelUrl = bundle.url(forResource: db.rawValue, withExtension: "omo", subdirectory: subdirectory)
        let standartModelUrl = bundle.url(forResource: db.rawValue, withExtension: "mom", subdirectory: subdirectory)

        guard let url = optimizedMpdelUrl ?? standartModelUrl else {
            throw PMigrationError.couldNotFindDatabaseVersion
        }

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            throw PMigrationError.couldNotFindDatabaseVersion
        }

        return model
    }
}
