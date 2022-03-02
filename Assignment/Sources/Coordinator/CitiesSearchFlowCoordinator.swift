//
//  CitiesSearchFlowCoordinator.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

class CitiesSearchFlowCoordinator: FlowCoordinator {
    fileprivate let window: UIWindow
    fileprivate var searchNavigationController: UINavigationController?
    fileprivate let dependencyProvider: CitiesSearchFlowCoordinatorDependencyProvider
    
    init(window: UIWindow, dependencyProvider: CitiesSearchFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchNavigationController = dependencyProvider.moviesSearchNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
    }
}
extension CitiesSearchFlowCoordinator: CitiesSearchNavigator {
    
    func showLocation(forCity viewModel: CityViewModel) {
        let controller = self.dependencyProvider.cityDetailsController(viewModel)
        searchNavigationController?.show(controller, sender: nil)
    }
}
