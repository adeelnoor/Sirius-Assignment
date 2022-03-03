//
//  CitiesSearchNavigator.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit
///`CitiesSearchNavigator` will be responsible for navigating
protocol CitiesSearchNavigator: AnyObject {
    /// Show location on map i.e. detail screen
    func showLocation(for viewModel: CityViewModel)
}
