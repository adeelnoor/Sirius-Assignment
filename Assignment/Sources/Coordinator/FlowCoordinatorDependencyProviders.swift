//
//  FlowCoordinatorDependencyProviders.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

/// The `ApplicationFlowCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationFlowCoordinator
protocol ApplicationFlowCoordinatorDependencyProvider: CitiesSearchFlowCoordinatorDependencyProvider {}

protocol CitiesSearchFlowCoordinatorDependencyProvider {
    ///Creates UIViewController to search for a city
    func citiesSearchNavigationController(navigator: CitiesSearchNavigator) -> UINavigationController

    ///Creates UIViewController to show the details of the city with specified viewModel
    func cityDetailsController(cityViewModel: CityViewModel) -> UIViewController
}
