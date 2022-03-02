//
//  ApplicationComponentsProvider.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

final class ApplicationComponentsProvider {
    
    private let fileProvider: FileServiceProvider
    fileprivate lazy var useCase: CitiesUseCase = CitiesUseCase(fileProvider.fileServiceType)
    
    init(servicesProvider: FileServiceProvider = FileServiceProvider.defaultProvider()) {
        self.fileProvider = servicesProvider
    }
}
extension ApplicationComponentsProvider: ApplicationFlowCoordinatorDependencyProvider {
    func moviesSearchNavigationController(navigator: CitiesSearchNavigator) -> UINavigationController {
        let viewModel = CitiesSearchViewModel(useCase: useCase, navigator: navigator)
        let citiesSearchViewController = CitiesSearchViewController(viewModel: viewModel)
        let citiesSearchNavigationController = UINavigationController(rootViewController: citiesSearchViewController)
        citiesSearchNavigationController.navigationBar.tintColor = .label
        return citiesSearchNavigationController
    }
    
    func cityDetailsController(_ cityViewModel: CityViewModel) -> UIViewController {
        //TODO: - Return detail ViewController
        return UIViewController()
    }
}
