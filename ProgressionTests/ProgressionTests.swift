//
//  ProgressionTests.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 20.02.2021.
//

import XCTest
import CoreData
@testable import Progression

//class ProgressionTests: XCTestCase {
//    var urlsToRemove = Set<URL>()
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        try self.urlsToRemove.forEach { (url) in
//            try FileManager().removeItem(at: url)
//        }
//        self.urlsToRemove.removeAll()
//    }

//    func testUpToDate() throws {
//        let url = Bundle(for: self.classForCoder).url(forResource: "Model", withExtension: "momd")!
//        let model = NSManagedObjectModel(contentsOf: url)!
//        let container = NSPersistentContainer(name: "Model", managedObjectModel: model)
//
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            assert(error == nil)
//        })
//
//        let first = FirstEntity(context: container.viewContext)
//        first.att1 = 13.0
//        first.att2 = "13"
//
//        let fetched = try container.viewContext.fetch(FirstEntity.fetchRequest()) as? [FirstEntity]
//
//        XCTAssertEqual(fetched?.first?.att1, 13.0)
//        XCTAssertEqual(fetched?.first?.att2, "13")
//
//        container.persistentStoreCoordinator.persistentStores.compactMap(\.url).forEach({ self.urlsToRemove.insert($0) })
//
//        //TODO: Migrate there
//    }
    
//    func testSingleMigration() throws {
//        let url = Bundle(for: self.classForCoder).url(forResource: "Model", withExtension: "momd")!
//        let omo1 = url.appendingPathComponent("Model.omo")
//        let mom1 = url.appendingPathComponent("Model.mom")
//        let omo2 = url.appendingPathComponent("Model2.omo")
//        let mom2 = url.appendingPathComponent("Model2.mom")
//
//        let oldModel: NSManagedObjectModel
//        if let model = NSManagedObjectModel(contentsOf: omo1) {
//            oldModel = model
//        } else if let model = NSManagedObjectModel(contentsOf: mom1) {
//            oldModel = model
//        } else {
//            fatalError()
//        }
//
//        print(oldModel.entities)
//        let oldContainer = NSPersistentContainer(name: "Model", managedObjectModel: oldModel)
//        oldContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            assert(error == nil)
//        })
//        let oldObject = NSEntityDescription.insertNewObject(forEntityName: "SecondEntity", into: oldContainer.viewContext)
//        oldObject.setValue("2 3 4", forKey: "att1")
//        try oldContainer.viewContext.save()
//
//        for url in oldContainer.persistentStoreCoordinator.persistentStores.compactMap(\.url) {
//
//            urlsToRemove.insert(url)
//        }
//
//        let newModel: NSManagedObjectModel
//        if let model = NSManagedObjectModel(contentsOf: omo2) {
//            newModel = model
//        } else if let model = NSManagedObjectModel(contentsOf: mom2) {
//            newModel = model
//        } else {
//            fatalError()
//        }
//
//        let newContainer = NSPersistentContainer(name: "Model", managedObjectModel: newModel)
//        let fetched = try newContainer.viewContext.fetch(SecondEntity.fetchRequest()) as? [SecondEntity]
//
//        XCTAssertEqual(fetched?.first?.att2, "2")
//        XCTAssertEqual(fetched?.first?.att3, "3")
//        XCTAssertEqual(fetched?.first?.att4, "4")
//    }
//
//    func testCreateDB() {
//        let url = Bundle(for: self.classForCoder).url(forResource: "Model", withExtension: "momd")!
//        let container = NSPersistentContainer(name: "Model", managedObjectModel: NSManagedObjectModel(contentsOf: url)!)
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            assert(error == nil)
//        })
//
//        for _ in 0..<10 {
//            let first = FirstEntity(context: container.viewContext)
//
//            first.att1 = .random(in: 5..<10)
//            first.att2 = .random(in: 10..<100)
//            first.att3 = .random(in: 100..<10_000)
//
//            var fourthSet = Set<FourthEntity>()
//            for _ in 0..<5 {
//                let fourth = FourthEntity(context: container.viewContext)
//
//                fourth.att1 = .random()
//                fourth.att2 = .random()
//                fourth.att3 = .random()
//
//                fourthSet.insert(fourth)
//            }
//            first.fourth = fourthSet as NSSet
//
//            let second = SecondEntity(context: container.viewContext)
//            second.attInt = .random(in: 0..<32000)
//            second.attStr = .random(length: 1_000)
//
//            let third = ThirdEntity(context: container.viewContext)
//            third.att1 = .init()
//
//            second.third = third
//
//            var fifthSet = Set<FifthEntity>()
//            for _ in 10..<50 {
//                let fifth = FifthEntity(context: container.viewContext)
//                fifth.att1 = .init(timeIntervalSinceNow: .random(in: -20_000_000...20_000_000))
//
//                fifthSet.insert(fifth)
//            }
//
//            second.fifth = fifthSet as NSSet
//
//            first.second = second
//        }
//
//        try! container.viewContext.save()
//
//        print(container.persistentStoreCoordinator.persistentStores.first?.url)
//    }
//
//    func testDB() {
//        let url = Bundle(for: self.classForCoder).url(forResource: "MM", withExtension: "momd")!
//        let container = NSPersistentContainer(name: "Model", managedObjectModel: NSManagedObjectModel(contentsOf: url)!)
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            assert(error == nil)
//        })
//        for _ in 0..<10_000 {
//            let first = FirstE(context: container.viewContext)
//            first.randomV = .random(in: 10..<32_000_000)
//        }
//
//        try! container.viewContext.save()
//
//        print(container.persistentStoreCoordinator.persistentStores.first?.url)
//    }
//}
//
//extension String {
//    static func random(length: Int = 20) -> String {
//        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        var randomString: String = ""
//
//        for _ in 0..<length {
//            let randomValue = arc4random_uniform(UInt32(base.count))
//            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
//        }
//        return randomString
//    }
//}
