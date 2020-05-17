//
//  DetailViewController.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/13/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstTypeLabel: UILabel!
    @IBOutlet weak var secondTypeLabel: UILabel!
    @IBOutlet weak var firstAbilityLabel: UILabel!
    @IBOutlet weak var firstAbilityDescriptionLabel: UILabel!
    @IBOutlet weak var secondAbilityLabel: UILabel!
    @IBOutlet weak var secondAbilityDescriptionLabel: UILabel!
    
    
    var viewModel: DetailViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.pokedexEntryURLFetched()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadUI()
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func reloadUI() {
        nameLabel.text = viewModel?.pokemon?.name
        setAbilityLabels()
        setTypeLabels()
        
    }
    
    //Would ability and type also be viewModel properties?
    private func setAbilityLabels() {
        let abilities = viewModel?.pokemon?.abilities
        
        if abilities?.count == 2 {
            firstAbilityLabel.text = abilities?[0].name
            firstAbilityDescriptionLabel.text = abilities?[0].effects[0].shortDescription
            secondAbilityLabel.text = abilities?[1].name
            secondAbilityDescriptionLabel.text = abilities?[1].effects[0].shortDescription
            secondAbilityLabel.isHidden = false
            secondAbilityDescriptionLabel.isHidden = false
        } else {
            firstAbilityLabel.text = abilities?[0].name
            firstAbilityDescriptionLabel.text = abilities?[0].effects[0].shortDescription
            secondAbilityLabel.isHidden = true
            secondAbilityDescriptionLabel.isHidden = true
        }
    }
    
    private func setTypeLabels() {
        let types = viewModel?.pokemon?.types
        
        if types?.count == 2 {
            firstTypeLabel.text = types?[0]
            secondTypeLabel.text = types?[1]
            secondTypeLabel.isHidden = false
        } else {
            firstTypeLabel.text = types?[0]
            secondTypeLabel.isHidden = true
        }
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


