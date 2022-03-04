//
//  FileService.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation
import Combine

class FileService: FileServiceType {
    
    @discardableResult
    func load() -> AnyPublisher<[City], Error> {
        guard let path = Bundle.main.path(forResource: AccessibilityIdentifiers.CitiesSearch.fileName, ofType: AccessibilityIdentifiers.CitiesSearch.fileType) else {
            return .fail(ErrorType.fileError)
        }
        do {
            ///Load all the cities from .json file and sort it
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            guard let cities = try? JSONDecoder().decode([City].self, from: data) else {
                return .fail(ErrorType.parsingError)
            }
            return .just(cities.sortedCites())
        } catch {
            return .fail(ErrorType.parsingError)
        }
    }
    
    @discardableResult
    func search(from cities: [City], name: String) -> AnyPublisher<[City], Error> {
        let filteredCities = cities.filter {
            //Return all cities with prefix of ""
            if name.isEmpty {
                return ($0.city.lowercased().hasPrefix(name.lowercased()))
            } else {
                //Return all cities matching range and hasPrefix
                return ($0.city.range(of: name, options: [.caseInsensitive]) != nil) && ($0.city.lowercased().hasPrefix(name.lowercased()))
            }
        }
        return .just(filteredCities)
    }
}
