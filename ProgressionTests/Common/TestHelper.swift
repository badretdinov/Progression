//
//  FileManager.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import Foundation
import Zip
import CoreData

class TestHelper {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func databaseUrl() -> URL {
        self.getDocumentsDirectory().appendingPathComponent("Model.sqlite")
    }
    
    static func deployDB(version: Int, bundle: Bundle) throws {
        let modelZip = bundle.url(forResource: "DB\(version)", withExtension: "zip")!
        print(self.getDocumentsDirectory())
        try Zip.unzipFile(modelZip, destination: self.getDocumentsDirectory(), overwrite: true, password: nil)
    }
    
    static func mainContext(modelUrl: URL) throws -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel(contentsOf: modelUrl)!)
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.databaseUrl(), options: nil)
        context.persistentStoreCoordinator = coordinator
        return context
    }
}