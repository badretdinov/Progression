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
        try migration.migrate(storeURL: dbURL, toVersion: .version3, bundle: Bundle.module)
    }

    func testUpToDateDBMigration() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle.module)

        let migration = PMigrationManager<DBVersion_Automatic>()
        try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle.module)

        try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle.module)
    }

    func testErrorUnknownVersion() throws {
        try TestHelper.deployDB(version: .wrong, bundle: Bundle.module)

        let migration = PMigrationManager<DBVersion_Automatic>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle.module), "") { (error) in
            var passed = false
            if case .unknownDatabaseVersionFound = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorMetadataFetch() throws {
        try TestHelper.deployDB(version: .nondb, bundle: Bundle.module)
        
        let migration = PMigrationManager<DBVersion_Automatic>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle.module), "") { (error) in
            var passed = false
            if case .couldNotFetchMetadata(_) = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorWrongName() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle.module)
        
        let migration = PMigrationManager<DBVersion_wrongName>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle.module), "") { (error) in
            var passed = false
            if case .couldNotFindDatabase = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorWrongVersion() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle.module)
        
        let migration = PMigrationManager<DBVersion_wrongVersion>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle.module), "") { (error) in
            var passed = false
            if case .couldNotFindDatabaseVersion = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorUnreachableVersion() throws {
        try TestHelper.deployDB(version: .latest, bundle: Bundle.module)
        
        let migration = PMigrationManager<DBVersion_Automatic>()
        XCTAssertThrowsError(try migration.migrate(storeURL: TestHelper.databaseUrl(), toVersion: .version1, bundle: Bundle.module), "") { (error) in
            var passed = false
            if case .destionationVersionIsUnreachable = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorNoMappingModel() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle.module)
        
        let migration = PMigrationManager<DBVersion_wrongNamed>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle.module), "") { (error) in
            var passed = false
            if case .couldNotFindMappingModel(from: _, to: _) = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
}
