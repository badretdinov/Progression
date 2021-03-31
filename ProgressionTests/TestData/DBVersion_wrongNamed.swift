//
//  DBVersion_wrongNamed.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 31.03.2021.
//

import Foundation
@testable import Progression

enum DBVersion_wrongNamed: String, PDatabaseVersion {
    static var databaseName = "Model"
    
    case version1 = "MM"
    case version2 = "MM2"
    case version3 = "MM3"
    
    var migrationTypes: [PDatabaseMigrationType] {
        switch self {
        case .version1:
            return []
        case .version2:
            return [.named("123")]
        case .version3:
            return [.named("456")]
        }
    }
}
