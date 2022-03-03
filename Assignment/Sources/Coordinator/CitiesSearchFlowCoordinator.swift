//
//  CitiesSearchFlowCoordinator.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

/// The `CitiesSearchFlowCoordinator` takes control over the flows on the cities search screen
class CitiesSearchFlowCoordinator: FlowCoordinator {
    fileprivate let window: UIWindow
    fileprivate var searchNavigationController: UINavigationController?
    fileprivate let dependencyProvider: CitiesSearchFlowCoordinatorDependencyProvider
    
    init(window: UIWindow, dependencyProvider: CitiesSearchFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchNavigationController = dependencyProvider.citiesSearchNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
    }
}
extension CitiesSearchFlowCoordinator: CitiesSearchNavigator {
    
    func showLocation(for viewModel: CityViewModel) {
        let controller = self.dependencyProvider.cityDetailsController(cityViewModel: viewModel)
        searchNavigationController?.show(controller, sender: nil)
    }
}
