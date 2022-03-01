//
//  CitiesSearchViewController.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import UIKit
import Combine

class CitiesSearchViewController: UIViewController {
    
    ///Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    
    ///Privates
    private var cancellables: [AnyCancellable] = []
    private let viewModel: CitiesSearchViewModelType
    private let didSelect = PassthroughSubject<CityViewModel, Never>()
    private let didSearch = PassthroughSubject<String, Never>()
    private let didAppear = PassthroughSubject<Void, Never>()
    private var cellId = "cellId"
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.placeholder = "SEARCH HERE"
        return searchController
    }()
    private lazy var dataSource = setupDataSource()
    
    init(viewModel: CitiesSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Not Supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel(viewModel)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppear.send(())
    }
    //MARK: - Setup View
    private func setupUI() {
        definesPresentationContext = true
        title = "Cities"
        tableView.tableFooterView = UIView()
        tableView.dataSource = dataSource
        navigationItem.searchController = self.searchController
        searchController.isActive = true
    }
    private func bindViewModel(_ viewModel: CitiesSearchViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = CitiesSearchViewModelInput(appear: didAppear.eraseToAnyPublisher(),
                                               search: didSearch.eraseToAnyPublisher(),
                                               select: didSelect.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.sink { [weak self] state in
            self?.updateState(state)
        }
        .store(in: &cancellables)
    }
    private func updateState(_ state: CitiesSearchState) {
        loadingView.isHidden = true
        switch state {
            case .loading:
                loadingView.isHidden = false
            case .success(let cities):
                update(with: cities)
            default:
                break
        }
    }
}
//MARK: - SearchBar Delegate
extension CitiesSearchViewController: UISearchBarDelegate {
    //TODO: - Add searchBar Delegates
}
//MARK: - TableView
fileprivate extension CitiesSearchViewController {
    enum Section: CaseIterable {
        case cities
    }
    func setupDataSource() -> UITableViewDiffableDataSource<Section, CityViewModel> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, cityViewModel in
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: self.cellId)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellId)
                cell.textLabel?.textAlignment = .left
                cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                cell.textLabel?.textColor = .black
                cell.selectionStyle = .none
                cell.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
            }
            cell.bind(to: cityViewModel)
            return cell
        }
    }
    func update(with cities: [CityViewModel]) {
        DispatchQueue.main.async { [unowned self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, CityViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(cities, toSection: .cities)
            self.dataSource.apply(snapshot)
        }
    }
}
