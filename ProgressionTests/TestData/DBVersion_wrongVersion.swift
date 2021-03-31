//
//  DBVersion_wrongVersion.swift
//  ProgressionTests
//
//  Created by Oleg Badretdinov on 31.03.2021.
//

import Foundation
@testable import Progression

enum DBVersion_wrongVersion: String, PDatabaseVersion {
    static var databaseName = "Model"
    
    case version1 = "MM123213"
}
