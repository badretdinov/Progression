//
//  MigrationTests.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import XCTest
import CoreData
@testable import Progression

class AutomaticMigrationTests: BaseTest {
    func testSingle() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle.module)

        let migration = PMigrationManager<DBVersion_Automatic>()
        try migration.migrate(storeURL: TestHelper.databaseUrl(), toVersion: .version2, bundle: Bundle.module)
        
        let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd")!.appendingPathComponent("MM2.mom")
        context = try TestHelper.mainContext(modelUrl: modelURL)

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FirstE")
        let results = try context?.fetch(request) as? [NSManagedObject] ?? []

        for item in results.lazy.shuffled().prefix(5) {
            let value = item.value(forKey: "randomV") as? Int64 ?? 0
            let value1 = item.value(forKey: "randomVplus1") as? Int64 ?? 0
            XCTAssertEqual(value + 1, value1)
        }
    }
    
    func testMultiple() throws {
        try TestHelper.deployDB(version: .normal, bundle: Bundle.module)
        
        let migration = PMigrationManager<DBVersion_Automatic>()
        try migration.migrate(storeURL: TestHelper.databaseUrl(), toVersion: .version3, bundle: Bundle.module)
        
        let modelURL = Bundle.module.url(forResource: "Model", withExtension: "momd")!.appendingPathComponent("MM3.mom")
        context = try TestHelper.mainContext(modelUrl: modelURL)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FirstE")
        let results = try context?.fetch(request) as? [NSManagedObject] ?? []
        
        for item in results.lazy.shuffled().prefix(5) {
            let value = item.value(forKey: "randomV") as? Int64 ?? 0
            let value1 = item.value(forKey: "randomVplus1") as? Int64 ?? 0
            let value3 = item.value(forKey: "randomVminus3") as? Int64 ?? 0
            XCTAssertEqual(value + 1, value1)
            XCTAssertEqual(value - 3, value3)
        }
    }
}
