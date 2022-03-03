//
//  CitiesSearchViewModel.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation
import Combine
import UIKit

final class CitiesSearchViewModel: CitiesSearchViewModelType {
    
    private var cancellables: [AnyCancellable] = []
    private weak var navigator: CitiesSearchNavigator?
    private let useCase: CitiesUseCaseType
    
    ///Data source
    private var cities = [City]()
    
    init(useCase: CitiesUseCaseType, navigator: CitiesSearchNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    func transform(input: CitiesSearchViewModelInput) -> CitiesSearchViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        //inital loading state
        let loadingState: CitiesSearchViewModelOutput = .just(.loading)
        ///Select  row i.e City
        input
            .select
            .sink(receiveValue: { viewModel in
                self.navigator?.showLocation(for: viewModel)
            })
            .store(in: &cancellables)
        
        ///Load all the cities
        let allCities = self.useCase.loadCitiesData()
            .map { result -> CitiesSearchState in
                switch result {
                    case .success(let cities):
                        self.cities = cities
                        return .success(self.viewModels(cities))
                    case .success(let cities) where cities.isEmpty:
                        return .empty
                    case .failure(let err):
                        return .error(err)
                }
            }
            .eraseToAnyPublisher()
        
        ///Load filtered cities
        let filteredCities = input
            .search.filter { _ in true }
            .flatMapLatest { text in
                self.useCase.searchCities(from: self.cities, with: text)
        }
            .map { result -> CitiesSearchState in
                switch result {
                    case .success(let cities):
                        return .success(self.viewModels(cities))
                    case .success(let cities) where cities.isEmpty:
                        return .empty
                    case .failure(let err):
                        return .error(err)
                }
            }
            .eraseToAnyPublisher()
        ///Return 3 Publishers, state, all the cities and filtered cities
        return Publishers
            .Merge3(loadingState, allCities, filteredCities)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
//MARK: - Mapping
private extension CitiesSearchViewModel {
    func viewModels(_ cities: [City]) -> [CityViewModel] {
        return cities.map {
            return CityViewModel(country: $0.country,
                                 name: $0.city,
                                 id: $0.id,
                                 coordinate: $0.coord)
        }
    }
}
