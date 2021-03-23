//
//  PDatabaseVersion.swift
//  Progression
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import Foundation
import CoreData

public protocol PDatabaseVersion: CaseIterable, Equatable, RawRepresentable where RawValue == String {
    static var databaseName: String { get }
    static var last: Self { get }
    static func compatibleVersionForStoreMetadata(_ metadata: [String : Any], bundle: Bundle) throws -> Self?
    
    var migrationTypes: [PDatabaseMigrationType] { get }
}

public extension PDatabaseVersion {
    static func compatibleVersionForStoreMetadata(_ metadata: [String : Any], bundle: Bundle) throws -> Self? {
        let compatibleVersion = try Self.allCases.first { version in
            let model = try NSManagedObjectModel.managedObjectModel(forDBVersion: version, bundle: bundle)
            
            return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
        }
        
        return compatibleVersion
    }
    
    static var last: Self {
        get {
            return Self.allCases[Self.allCases.index(Self.allCases.endIndex, offsetBy: -1)]
        }
    }
    
    var migrationTypes: [PDatabaseMigrationType] {
        return [.automatic]
    }
}

public enum PDatabaseMigrationType {
    case automatic
    case named(String)
    case inferred
}
