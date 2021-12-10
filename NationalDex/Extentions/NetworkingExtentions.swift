//
//  NetworkingExtentions.swift
//  NationalDex
//
//  Created by Kendall Poindexter on 12/9/21.
//  Copyright © 2021 Kendall Poindexter. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isHttpResponseValid: Bool {
        (200...299).contains(self.statusCode)
    }
}
