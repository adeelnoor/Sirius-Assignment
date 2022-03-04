//
//  ApplicationFlowCoordinatorTests.swift
//  AssignmentTests
//
//  Created by Adeel-dev on 3/4/22.
//

import Foundation
import XCTest
@testable import Assignment

class ApplicationFlowCoordinatorTests: XCTestCase {
    private let window =  UIWindow()
    private let dependencyProvider = ApplicationFlowCoordinatorDependencyProviderMock()
    
    private lazy var flowCoordinator = ApplicationFlowCoordinator(window: window, dependencyProvider: dependencyProvider)
    
    /// Test that application flow is started correctly
    func test_startsApplicationFlow() {
        //GIVEN
        let rootViewController = UINavigationController()
        dependencyProvider.citiesSearchNavigationControllerReturnValue = rootViewController
        
        //WHEN
        flowCoordinator.start()
        
        //THEN
        XCTAssertEqual(window.rootViewController, rootViewController)
    }
}
