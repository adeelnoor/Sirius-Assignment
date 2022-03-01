//
//  CitiesSearchNavigator.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

protocol CitiesSearchNavigator: AnyObject {
    /// Show location on map i.e. detail screen
    func showLocation(forCity viewModel: CityViewModel)
}
