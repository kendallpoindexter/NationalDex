//
//  FavoritesController.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 5/18/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import Foundation

class FavoritesController {
    var names:[String] {
        get {UserDefaults.standard.object(forKey: "names") as? [String] ?? []}
        set {UserDefaults.standard.set(newValue, forKey: "names")}

    }
    
    func removeObject(with name: String) {
        UserDefaults.standard.removeObject(forKey: name)
    }
    
}
