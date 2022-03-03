//
//  UITableViewCell+Common.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit

extension UITableViewCell {
    ///Binding cell with ViewModel
    func bind(to viewModel: CityViewModel) {
        textLabel?.text = viewModel.title
        detailTextLabel?.text = viewModel.coordinates
    }
}
