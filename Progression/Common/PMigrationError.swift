//
//  PMigrationError.swift
//  Progression
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import Foundation
import CoreData

public enum PMigrationError: Error {
    case couldNotFetchMetadata(Error)
    case couldNotReplaceStore(Error)
    case couldNotFindDatabase
    case couldNotFindDatabaseVersion
    case unknownDatabaseVersionFound
    case destionationVersionIsUnreachable
    case walCheckpointFailed(Error)
    case couldNotFindMappingModel(from: NSManagedObjectModel, to: NSManagedObjectModel)
    case couldNotMigrate(from: NSManagedObjectModel, to: NSManagedObjectModel, error: Error)
}
