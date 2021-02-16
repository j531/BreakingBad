//
//  NSDiffableDataSourceSnapshot.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 21/11/2020.
//

import Foundation
import UIKit

extension NSDiffableDataSourceSnapshot {
    static var allItemsRemoved: Self {
        var snapshot = Self()
        snapshot.deleteAllItems()
        return snapshot
    }
}
