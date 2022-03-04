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
    private let cities = PassthroughSubject<[City], Never>()
    private var cellId = "cellId"
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autoresizingMask = .flexibleWidth
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.placeholder = "Search here..."
        return searchController
    }()
    private lazy var dataSource = setupDataSource()
    fileprivate var snapshot = NSDiffableDataSourceSnapshot<Section, CityViewModel>()
    
    init(viewModel: CitiesSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        setupUI()
        bindViewModel(viewModel)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK: - Setup View
    private func setupUI() {
        definesPresentationContext = true
        title = "Cities"
        //Setup tableView datasource
        tableView.dataSource = dataSource
        navigationController?.navigationBar.isTranslucent = true
        tableView.tableHeaderView = searchController.searchBar
    }
    //MARK: - Bindings
    private func bindViewModel(_ viewModel: CitiesSearchViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = CitiesSearchViewModelInput(search: didSearch.eraseToAnyPublisher(),
                                               select: didSelect.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output
            .sink { [weak self] state in
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
            case .error(let error):
                alert(title: "Error", message: error.localizedDescription)
            case .empty:
                break
        }
    }
}
//MARK: - SearchBar Delegate
extension CitiesSearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            didSearch.send(searchText)
        } else {
            didSearch.send("")
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        didSearch.send("")
    }
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
                cell.selectionStyle = .default
                cell.backgroundColor = .white
            }
            cell.bind(to: cityViewModel)
            return cell
        }
    }
    func update(with cities: [CityViewModel]) {
        snapshot = NSDiffableDataSourceSnapshot<Section, CityViewModel>()
        snapshot.deleteAllItems()
        
        DispatchQueue.main.async {
            
            self.snapshot.appendSections(Section.allCases)
            self.snapshot.appendItems(cities, toSection: .cities)
            
            self.dataSource.apply(self.snapshot, animatingDifferences: true, completion: nil)
        }
    }
}
//MARK: - UItableView Delegates
extension CitiesSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        let snapshot = dataSource.snapshot()
        didSelect.send(snapshot.itemIdentifiers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
