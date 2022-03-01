//
//  CitiesSearchViewModel.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation
import Combine

final class CitiesSearchViewModel: CitiesSearchViewModelType {
    
    private var cancellables: [AnyCancellable] = []
    private weak var navigator: CitiesSearchNavigator?
    private let useCase: CitiesUseCaseType
    
    init(useCase: CitiesUseCaseType, navigator: CitiesSearchNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    func transform(input: CitiesSearchViewModelInput) -> CitiesSearchViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.select.sink(receiveValue: { viewModel in
            self.navigator?.showLocation(forCity: viewModel)
        })
            .store(in: &cancellables)
        
        let searchInput = input
            .search
            .throttle(for: .milliseconds(3000), scheduler: Scheduler.mainScheduler, latest: true)
            .removeDuplicates()
        let cities = searchInput
            .filter { !$0.isEmpty }
            .flatMapLatest { query in
                self.useCase.searchCities(with: query)
            }
            .map { result -> CitiesSearchState in
                switch result {
                    case .success(let cities):
                        return .success(self.viewModels(cities))
                    case .success(let cities) where cities.isEmpty:
                        return .empty
                    case .failure(let error):
                        print("Error searching Cities",error.localizedDescription)
                        return .empty
                }
            }
            .eraseToAnyPublisher()
        
        let loadingState: CitiesSearchViewModelOutput = .just(.loading)
        return Publishers
            .Merge(loadingState, cities)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
//MARK: - Map - cities
private extension CitiesSearchViewModel {
    func viewModels(_ cities: [City]) -> [CityViewModel] {
        return cities.map {
            return CityViewModel(country: $0.country,
                                 name: $0.name,
                                 id: $0.id,
                                 coordinate: $0.coord)
        }
    }
}
