//
//  DBVersion.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 21.02.2021.
//

import Foundation
@testable import Progression

enum DBVersion_Automatic: String, PDatabaseVersion {
    static var databaseName = "Model"
    
    case version1 = "MM"
    case version2 = "MM2"
    case version3 = "MM3"
    
    var migrationTypes: [PDatabaseMigrationType] {
        return [.automatic]
    }
}
