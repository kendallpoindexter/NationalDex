//
//  ViewController.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/11/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import UIKit

class HomeTableViewController: UIViewController {
    enum Section {
        case main
    }
    
    @IBOutlet weak var homeTableView: UITableView!
     
    private let viewModel = HomeTableViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var dataSource: UITableViewDiffableDataSource<Section, PokedexEntry>?
    
    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        self.configureDataSource()

        viewModel.fetchPokedexEntries { result in
            switch result {
            case .success:
                self.updateUI()
            case .failure(let error):
                print(error)
            }
        }
        
        configureSearchController()
    }
    
    private func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource(tableView: self.homeTableView, cellProvider: { (tableView, indexPath, entry) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "pokedexEntryCell", for: indexPath)
            cell.textLabel?.text = entry.name
            return cell
        })
    }
    
    private func updateUI() {
         var snapShot = NSDiffableDataSourceSnapshot<Section, PokedexEntry>()
         snapShot.appendSections([.main])
        
        if isFiltering {
            snapShot.appendItems(viewModel.filteredPokemonEntry)
        } else {
            snapShot.appendItems(viewModel.pokedexEntries)
        }
        
         dataSource?.apply(snapShot)
     }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemon by Name"
        navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
    }
    
    private func filterSearchText(with text: String) {
        viewModel.filteredPokemonEntry = viewModel.pokedexEntries.filter({
            $0.name.lowercased().contains(text.lowercased())
        })
        
        updateUI()
    }
    
}

//MARK: - Navigation

extension HomeTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = homeTableView.indexPathForSelectedRow else { return }
        guard let destination = segue.destination as? DetailViewController else { return }
        
        if isFiltering {
            destination.viewModel = viewModel.detailViewModelWithFilteredEntries(at: indexPath.row)
        } else {
            destination.viewModel = viewModel.detailViewModel(at: indexPath.row)
        }
    }
}

//MARK: - TableView Delegate Methods
extension HomeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - SearchController Methods

extension HomeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        //should this be forced unwrapped? In my thoughts it should be because if we are updating search results then we must have user entered search text
        filterSearchText(with: searchBarText!)
    }
}
