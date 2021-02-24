//
//  PMigrationError.swift
//  Progression
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import Foundation

public enum PMigrationError: Error {
    case couldNotFetchMetadata(Error)
    case couldNotAddPersistentStore(Error)
    case couldNotReplaceStore(Error)
    case couldNotFindDatabase
    case couldNotFindDatabaseVersion
    case unknownDatabaseVersionFound
    case destionationVersionIsUnreachable
    case walCheckpointFailed(Error)
}
