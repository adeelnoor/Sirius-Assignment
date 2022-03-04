//
//  AutoMockable.generated.swift
//  AssignmentTests
//
//  Created by Adeel-dev on 3/4/22.
//

import Foundation
import Combine
import XCTest
@testable import Assignment

class CitiesSearchNavigatorMock: CitiesSearchNavigator {

    //MARK: - showDetails
    var showDetailsForCityReceivedViewModel: CityViewModel?
    var showDetailsForCityClosure: ((CityViewModel) -> Void)?

    func showLocation(for viewModel: CityViewModel) {
        showDetailsForCityReceivedViewModel = viewModel
        showDetailsForCityClosure?(viewModel)
    }
}

class CitiesUseCaseTypeMock: CitiesUseCaseType {
    //MARK: - searchCities
    var searchCitiesWithReceivedName: String?
    var searchCitiesWithReceivedInvocations: [String] = []
    var searchCitiesWithReturnValue: AnyPublisher<Result<[City], Error>, Never>!
    var searchCitiesWithClosure: ((String) -> AnyPublisher<Result<[City], Error>, Never>)?
    
    func searchCities(from cities: [City], with name: String) -> AnyPublisher<Result<[City], Error>, Never> {
        searchCitiesWithReceivedName = name
        searchCitiesWithReceivedInvocations.append(name)
        return searchCitiesWithClosure.map { $0(name) } ?? searchCitiesWithReturnValue
    }
    
    var cityDetailsWithReceivedViewModel: CityViewModel?
    var cityDetailsWithReceivedInvocations: [CityViewModel] = []
    var cityDetailsWithReturnValue: AnyPublisher<Result<[City], Error>, Never>!
    var cityDetailsWithClosure: ((Int) -> AnyPublisher<Result<City, Error>, Never>)?
    
    //MARK: - Cities Data
    func loadCitiesData() -> AnyPublisher<Result<[City], Error>, Never> {
        return cityDetailsWithReturnValue
    }
}

class ApplicationFlowCoordinatorDependencyProviderMock: ApplicationFlowCoordinatorDependencyProvider {
    
    var citiesSearchNavigationControllerReturnValue: UINavigationController?
    func citiesSearchNavigationController(navigator: CitiesSearchNavigator) -> UINavigationController {
        return citiesSearchNavigationControllerReturnValue!
    }
    
    var cityDetailsControllerReturnValue: UIViewController!
    func cityDetailsController(cityViewModel: CityViewModel) -> UIViewController {
        return cityDetailsControllerReturnValue!
    }
}
