//
//  CitiesUseCase.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation
import Combine

final class CitiesUseCase: CitiesUseCaseType {
    
    private let fileService: FileServiceType
    
    init(_ fileService: FileServiceType) {
        self.fileService = fileService
    }
    
    func searchCities(from cities: [City], with name: String) -> AnyPublisher<Result<[City], Error>, Never> {
        let cities = cities.filter {
            $0.city.hasPrefix(name)
        }
        return .just(.success(cities))
    }
    
    func loadCitiesData() -> AnyPublisher<Result<[City], Error>, Never> {
        return fileService.load()
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[City], Error>, Never> in .just(.failure(error))}
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
}
protocol CitiesUseCaseType {
    /// Runs cities search with a query string
    func searchCities(from cities: [City], with name: String) -> AnyPublisher<Result<[City], Error>, Never>
    func loadCitiesData() -> AnyPublisher<Result<[City], Error>, Never>
}
