//
//  FlowCoordinator.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation

/// A `FlowCoordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol FlowCoordinator: AnyObject {

    /// Stars the flow
    func start()
}
