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
    
    static func replaceStore(at targetURL: URL, withStoreAt sourceURL: URL) throws {
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.replacePersistentStore(at: targetURL, destinationOptions: nil, withPersistentStoreFrom: sourceURL, sourceOptions: nil, ofType: NSSQLiteStoreType)
        } catch let error {
            throw PMigrationError.couldNotReplaceStore(error)
        }
    }
}
