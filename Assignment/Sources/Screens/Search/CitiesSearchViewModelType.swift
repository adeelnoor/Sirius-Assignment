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
    let select: AnyPublisher<Int, Never>
}

enum CitiesSearchState {
    case none //inital or idle state
    case loading
    case success([CityViewModel])
    case empty //no results or empty results
    case error(Error)
}


typealias CitiesSearchViewModelOutput = AnyPublisher<CitiesSearchState, Never>

protocol CitiesSearchViewModelType {
    func transform(input: CitiesSearchViewModelInput) -> CitiesSearchViewModelOutput
}
