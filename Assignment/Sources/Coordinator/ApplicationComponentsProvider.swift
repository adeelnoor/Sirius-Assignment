//
//  ApplicationComponentsProvider.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

/// The `ApplicationComponentsProvider` takes responsibity of creating application components and establishing dependencies between them.
final class ApplicationComponentsProvider {
    
    private let fileProvider: FileServiceProvider
    fileprivate lazy var useCase: CitiesUseCase = CitiesUseCase(fileProvider.fileServiceType)
    
    init(servicesProvider: FileServiceProvider = FileServiceProvider.defaultProvider()) {
        self.fileProvider = servicesProvider
    }
}
extension ApplicationComponentsProvider: ApplicationFlowCoordinatorDependencyProvider {
    func citiesSearchNavigationController(navigator: CitiesSearchNavigator) -> UINavigationController {
        let viewModel = CitiesSearchViewModel(useCase: useCase, navigator: navigator)
        let citiesSearchViewController = CitiesSearchViewController(viewModel: viewModel)
        let citiesSearchNavigationController = UINavigationController(rootViewController: citiesSearchViewController)
        citiesSearchNavigationController.navigationBar.tintColor = .label
        return citiesSearchNavigationController
    }
    
    func cityDetailsController(cityViewModel: CityViewModel) -> UIViewController {
        return CityDetailViewController(viewModel: cityViewModel)
    }
}
