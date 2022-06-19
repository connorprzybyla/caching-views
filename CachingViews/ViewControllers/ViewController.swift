//
//  ViewController.swift
//  CachingViews
//
//  Created by Connor Przybyla on 6/19/22.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private let cellID = "CellID"
    private let tableView = UITableView()
    private let searchController = UISearchController()
    private var viewModel: ViewModel
    private var datasource: TableDataSource?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        reloadData()
        setupSearchController()
        setupAutoLayout()
    }
    
    // MARK: Initializers
    
    init(viewModel: any ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController {
    
    private func setupTableView() {
        datasource = TableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, name) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
            cell.textLabel?.text = name
            return cell
        })
        
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.filteredNames, toSection: .main)
        datasource?.apply(snapshot)
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.rightBarButtonItem = addButton
        tableView.tableHeaderView = searchController.searchBar
    }
    
    @objc private func addNewPerson() {
        let alertController = UIAlertController(title: "Add a new name", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Submit", style: .default) { [weak self] alert in
            self?.viewModel.filteredNames.append(alertController.textFields![0].text! as String)
            self?.viewModel.names.append(alertController.textFields![0].text! as String)
            self?.reloadData()
        }
        alertController.addTextField()
        alertController.addAction(saveAction)
        present(alertController, animated: true)
    }
                                       
    private func setupAutoLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) within \(indexPath.section) tapped!")
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray5
        present(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > (tableView.contentSize.height-100 - scrollView.frame.size.height) {
            // TODO: call view model and get more data if not already fetching
            print("Get some more data!")
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indices = indexPaths.map { "\($0.row)" }.joined(separator: ", ")
        print("Prefetching for rows \(indices)")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let indices = indexPaths.map { "\($0.row)" }.joined(separator: ", ")
        print("Canceling prefetching for rows \(indices)")
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredNames = searchText.isEmpty ? viewModel.names : viewModel.filteredNames.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

