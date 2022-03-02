//
//  CitiesSearchViewModelType.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation
import Combine

struct CitiesSearchViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
    /// called when the user selected an item from the list
    let select: AnyPublisher<CityViewModel, Never>
}

enum CitiesSearchState {
    case loading
    case success([CityViewModel])
    case empty //no results or empty results
}
enum ErrorType: Error {
    case parsingError
    case fileError
    case commonError
}
extension CitiesSearchState: Equatable {
    static func == (lhs: CitiesSearchState, rhs: CitiesSearchState) -> Bool {
        switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.success(let lhsCities), .success(let rhsCities)):
                return lhsCities == rhsCities
            case (.empty, .empty):
                return true
            default:
                return false
        }
    }
}

typealias CitiesSearchViewModelOutput = AnyPublisher<CitiesSearchState, Never>

protocol CitiesSearchViewModelType {
    func transform(input: CitiesSearchViewModelInput) -> CitiesSearchViewModelOutput
}
