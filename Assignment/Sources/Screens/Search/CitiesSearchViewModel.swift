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
    private var filteredCities = [City]()
    
    init(useCase: CitiesUseCaseType, navigator: CitiesSearchNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    func transform(input: CitiesSearchViewModelInput) -> CitiesSearchViewModelOutput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input
            .select
            .sink(receiveValue: { viewModel in
                self.navigator?.showLocation(forCity: viewModel)
            })
            .store(in: &cancellables)
        
        let searchInput = input
            .search
            .throttle(for: .milliseconds(3000), scheduler: Scheduler.mainScheduler, latest: true)
            .removeDuplicates()
        input.search.sink { text in
            self.filteredCities = self.cities.filter {
                return $0.city.lowercased().hasPrefix(text.lowercased())
            }
            //Reload with filtered array
        }
        .store(in: &cancellables)
        let _cities = self.useCase.loadCitiesData()
            .map { result -> CitiesSearchState in
                switch result {
                    case .success(let cities):
                        self.cities = cities
                        return .success(self.viewModels(cities))
                    case .success(let cities) where cities.isEmpty:
                        return .empty
                    case .failure(let error):
                        print("Error searching Cities",error.localizedDescription)
                        return .empty
                }
            }
            .eraseToAnyPublisher()
        searchInput
            .filter { !$0.isEmpty }
            .flatMapLatest { text in
                self.useCase.searchCities(from: self.cities, with: text)
            }
            .map { result -> CitiesSearchState in
                switch result {
                    case .success(let cities):
                        return .success(self.viewModels(cities))
                    case .failure(let err):
                        print(err)
                }
                return .loading
            }
//            .receive(on: Scheduler.mainScheduler)
//            .eraseToAnyPublisher()
            .sink { _ in }
            .store(in: &cancellables)
        
//        let cities = searchInput
//            .filter { !$0.isEmpty }
//            .flatMapLatest { query in
//                self.useCase.searchCities(with: query)
//            }
//            .map { result -> CitiesSearchState in
//                switch result {
//                    case .success(let cities):
//                        return .success(self.viewModels(cities))
//                    case .success(let cities) where cities.isEmpty:
//                        return .empty
//                    case .failure(let error):
//                        print("Error searching Cities",error.localizedDescription)
//                        return .empty
//                }
//            }
//            .eraseToAnyPublisher()
        
        let loadingState: CitiesSearchViewModelOutput = .just(.loading)
//        return Publishers
//            .Merge(loadingState, _cities)
//            .removeDuplicates()
//            .eraseToAnyPublisher()
        
        return Publishers.MergeMany(loadingState, _cities, .just(.success(viewModels(filteredCities))))
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
//MARK: - Map - cities
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
