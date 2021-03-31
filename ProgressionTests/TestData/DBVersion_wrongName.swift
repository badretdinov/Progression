//
//  DBVersion_wrongName.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 31.03.2021.
//

import Foundation
@testable import Progression

enum DBVersion_wrongName: String, PDatabaseVersion {
    static var databaseName = "Model123"
    
    case version1 = "MM"
    case version2 = "MM2"
    case version3 = "MM3"
}
