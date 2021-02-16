//
//  Collection.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 22/11/2020.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
