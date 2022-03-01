//
//  CitiesUseCase.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation
import Combine

class CitiesUseCase: NSObject {

}
protocol CitiesUseCaseType {
    /// Runs cities search with a query string
    func searchCities(with name: String) -> AnyPublisher<Result<[City], Error>, Never>
}
