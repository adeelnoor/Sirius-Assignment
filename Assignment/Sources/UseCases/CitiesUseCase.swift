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
    func loadCitiesData() -> AnyPublisher<Result<[City], Error>, Never> {
        return fileService.load()
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[City], Error>, Never> in
                .just(.failure(error))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler) //background thread, no UI block
            .receive(on: Scheduler.mainScheduler)  //receive on main thread
            .eraseToAnyPublisher()
    }
    func searchCities(from cities: [City], with name: String) -> AnyPublisher<Result<[City], Error>, Never> {
        return fileService.search(from: cities, name: name)
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[City], Error>, Never> in
                .just(.failure(error))
            }
            .eraseToAnyPublisher()
    }
}
protocol CitiesUseCaseType {
    /// Runs cities search with a query string
    func searchCities(from cities: [City], with name: String) -> AnyPublisher<Result<[City], Error>, Never>
    ///Returns alll the cities from file
    func loadCitiesData() -> AnyPublisher<Result<[City], Error>, Never>
    
}
