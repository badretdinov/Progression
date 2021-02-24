//
//  MigrationTests.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import XCTest
import CoreData
@testable import Progression

class ProgressionTests: XCTestCase {
//    func testMigration_1() throws {
//        try FileManager.deployDB(version: 1, bundle: Bundle(for: Self.self))
//
//        let url = Bundle(for: self.classForCoder).url(forResource: "Model", withExtension: "momd")!
////        let container = NSPersistentContainer(name: "Model", managedObjectModel: NSManagedObjectModel(contentsOf: url)!)
////        let urls = container.persistentStoreDescriptions.compactMap(\.url)
//
//        let migration = PMigrationManager<DBVersion>()
//        migration.migrate(storeURL: FileManager.databaseUrl(), toVersion: .version2, bundle: Bundle(for: Self.self))
////        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
////            assert(error == nil)
////        })
//    }
    
    func testMigration_2() throws {
        try FileManager.deployDB(version: 1, bundle: Bundle(for: Self.self))
        let dbURL = FileManager.databaseUrl()
        
        let migration = PMigrationManager<DBVersion>()
        try migration.migrate(storeURL: dbURL, toVersion: .version3, bundle: Bundle(for: Self.self))
    }
    
    func testMigration_3() throws {
        
    }
}
