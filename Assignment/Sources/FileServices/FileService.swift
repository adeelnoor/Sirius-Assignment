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
        let cities = cities.filter {
//            if let _ = $0.city.range(of: name) {
//                return true
//            }
//            return false
            $0.city.hasPrefix(name)
        }
//        let _asd = cities.sortedCites().prefix(20).map {
//            return $0
//        }
        return .just(cities.sortedCites())
    }
}
