//
//  GeneralTests.swift
//  AssignmentTests
//
//  Created by Adeel-dev on 3/4/22.
//

import XCTest
@testable import Assignment

class GeneralTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
    }
}
//MARK: -
extension GeneralTests {
    //MARK: - Decoding & optionals
    func testDecodingAndOptionals() {
        /// When the Data initializer is throwing an error, the test will fail.
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else {
            //return with test fail
            XCTFail("Can't find search.json file")
            return
        }
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) {
            do {
                /// The `XCTAssertNoThrow` can be used to get extra context about the throw
                XCTAssertNoThrow(try JSONDecoder().decode([City].self, from: data))
                let cities = try? JSONDecoder().decode([City].self, from: data)
                /// Checking not nil and equal
                ///Will pass as expected
                let city = cities?.first
                XCTAssertNotNil(city?.id)
                XCTAssertEqual(city?.city, "Hurzuf")
                XCTAssertEqual(city?.country, "UA")
                XCTAssertEqual(city?.coord, Coordinate(lon: 34.283333, lat: 44.549999))
            }
        }
    }
}
