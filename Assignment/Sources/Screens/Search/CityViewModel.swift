//
//  CityViewModel.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Combine
import Foundation

protocol CityTitleProtocol {
    var title: String { get }
}
protocol CityCoordinatesProtocol {
    var coordinates: String { get }
}

struct CityViewModel {
    let country: String
    let name: String
    let id: Int
    let coord: Coordinate
    
    init(country: String, name: String, id: Int, coordinate: Coordinate) {
        self.country = country
        self.name = name
        self.id = id
        self.coord = coordinate
    }
}
struct Coordinate {
    let lon: Double
    let lat: Double
    
    init(lon: Double, lat: Double) {
        self.lon = lon
        self.lat = lat
    }
}
extension CityViewModel: Hashable {
    static func == (lhs: CityViewModel, rhs: CityViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
//MARK: - City detail properties
extension CityViewModel: CityTitleProtocol, CityCoordinatesProtocol {
    var title: String {
        return "\(name), \(country)"
    }
    var coordinates: String {
        return "\(coord.lat), \(coord.lon)"
    }
}
