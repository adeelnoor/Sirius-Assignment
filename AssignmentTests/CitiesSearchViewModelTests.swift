//
//  CitiesSearchViewModelTests.swift
//  AssignmentTests
//
//  Created by Adeel-dev on 3/4/22.
//

import Foundation
import XCTest
import Combine
@testable import Assignment

class CitiesSearchViewModelTests: XCTestCase {

    private let useCase = CitiesUseCaseTypeMock()
    private let navigator = CitiesSearchNavigatorMock()
    private var viewModel: CitiesSearchViewModel!
    private var cancellables: [AnyCancellable] = []
    
    override func setUp() {
        viewModel = CitiesSearchViewModel(useCase: useCase, navigator: navigator)
    }
    func test_loadData() {
        let search = PassthroughSubject<String, Never>()
        let input = CitiesSearchViewModelInput(search: search.eraseToAnyPublisher(), select: .empty())
        var state: CitiesSearchState?
        let expectation = self.expectation(description: "Cities")
        let cities = Util.loadFromFile("cities")
        let expectedViewModels = cities.map {
            return CityViewModel(country: $0.country, name: $0.city, id: $0.id, coordinate: $0.coord)
        }
        useCase.searchCitiesWithReturnValue = .just(.success(cities))
        viewModel.transform(input: input).sink { value in
            guard case CitiesSearchState.success = value else { return }
            state = value
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        //When
        search.send("Sydn")
        
        //then
        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssertEqual(state!, .success(expectedViewModels))
    }
    
    func test_hasErrorState() {
        //GIVEN
        let search = PassthroughSubject<String, Never>()
        let input = CitiesSearchViewModelInput(search: search.eraseToAnyPublisher(), select: .empty())
        var state: CitiesSearchState?
        let expectation = self.expectation(description: "cities")
        useCase.searchCitiesWithReturnValue = .just(.failure(ErrorType.fileError))
        viewModel.transform(input: input)
            .sink { value in
                guard case .error(_) = value else { return }
                state = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        //When
        search.send("Sydn")
        
        //Then
        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssertEqual(state!, .error(ErrorType.commonError))
    }
}
