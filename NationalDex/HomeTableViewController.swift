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
    private var dataSource: UITableViewDiffableDataSource<Section, PokedexEntry>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDataSource()

        viewModel.fetchPokedexEntries { result in
            switch result {
            case .success:
                self.updateUI()
            case .failure(let error):
                print(error)
            }
        }
        
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
         snapShot.appendItems(viewModel.pokedexEntries)
         dataSource?.apply(snapShot)
     }
}

