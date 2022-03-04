//
//  Utils.swift
//  AssignmentTests
//
//  Created by Adeel-dev on 3/4/22.
//

import XCTest
@testable import Assignment


class Util {
    static func loadFromFile(_ filename: String) -> [City] {
        let path = Bundle.main.path(forResource: AccessibilityIdentifiers.CitiesSearch.fileName, ofType: AccessibilityIdentifiers.CitiesSearch.fileType)
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
            return try JSONDecoder().decode([City].self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
    
