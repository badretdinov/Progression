//
//  PMigrationManagerTests.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 31.03.2021.
//

import XCTest
import CoreData
@testable import Progression

class PMigrationManagerTests: BaseTest {
    func testEmptyURL() throws {
        let dbURL = TestHelper.getDocumentsDirectory().appendingPathComponent("model123.sqlite")

        let migration = PMigrationManager<DBVersion_Automatic>()
        try migration.migrate(storeURL: dbURL, toVersion: .version3, bundle: Bundle(for: Self.self))
    }
    
    func testUpToDateDBMigration() throws {
        try TestHelper.deployDB(version: 1, bundle: Bundle(for: Self.self))
        
        let migration = PMigrationManager<DBVersion_Automatic>()
        try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self))
        
        try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self))
    }
}
