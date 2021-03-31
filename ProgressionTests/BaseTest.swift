//
//  BaseTest.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 31.03.2021.
//

import XCTest
import CoreData
@testable import Progression

class BaseTest: XCTestCase {
    var context: NSManagedObjectContext?
    
    override func tearDown() {
        for store in context?.persistentStoreCoordinator?.persistentStores ?? [] {
            try? context?.persistentStoreCoordinator?.remove(store)
        }
    }
}
