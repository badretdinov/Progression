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
        try TestHelper.deployDB(version: .normal, bundle: Bundle(for: Self.self))

        let migration = PMigrationManager<DBVersion_Automatic>()
        try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self))

        try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self))
    }

    func testErrorUnknownVersion() throws {
        try TestHelper.deployDB(version: .wrong, bundle: Bundle(for: Self.self))

        let migration = PMigrationManager<DBVersion_Automatic>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self)), "") { (error) in
            var passed = false
            if case .unknownDatabaseVersionFound = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorMetadataFetch() throws {
        try TestHelper.deployDB(version: .nondb, bundle: Bundle(for: Self.self))
        
        let migration = PMigrationManager<DBVersion_Automatic>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self)), "") { (error) in
            var passed = false
            if case .couldNotFetchMetadata(_) = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorWrongName() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle(for: Self.self))
        
        let migration = PMigrationManager<DBVersion_wrongName>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self)), "") { (error) in
            var passed = false
            if case .couldNotFindDatabase = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorWrongVersion() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle(for: Self.self))
        
        let migration = PMigrationManager<DBVersion_wrongVersion>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self)), "") { (error) in
            var passed = false
            if case .couldNotFindDatabaseVersion = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorUnreachableVersion() throws {
        try TestHelper.deployDB(version: .latest, bundle: Bundle(for: Self.self))
        
        let migration = PMigrationManager<DBVersion_Automatic>()
        XCTAssertThrowsError(try migration.migrate(storeURL: TestHelper.databaseUrl(), toVersion: .version1, bundle: Bundle(for: Self.self)), "") { (error) in
            var passed = false
            if case .destionationVersionIsUnreachable = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
    
    func testErrorNoMappingModel() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle(for: Self.self))
        
        let migration = PMigrationManager<DBVersion_wrongNamed>()
        XCTAssertThrowsError(try migration.migrateStoreIfNeeded(storeURL: TestHelper.databaseUrl(), bundle: Bundle(for: Self.self)), "") { (error) in
            var passed = false
            if case .couldNotFindMappingModel(from: _, to: _) = error as? PMigrationError {
                passed = true
            }
            XCTAssertTrue(passed)
        }
    }
}
