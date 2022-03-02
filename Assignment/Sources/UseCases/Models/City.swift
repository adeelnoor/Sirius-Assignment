//
//  City.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

struct City: Codable {
    let country: String
    let city: String
    let id: Int
    let coord: Coordinate
    
    //Added `CodingKeys` to decode "_id" key from json to right value
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case country
        case city = "name"
        case coord
    }
}
extension Array where Element == City {
    //Sort the cities name alphabetically
    func sortedCites() -> [Element] {
        return sorted {
            return $0.city.localizedLowercase < $1.city.localizedLowercase
        }
    }
}
