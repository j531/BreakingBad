//
//  NSDirectionalEdgeInsets.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 20/11/2020.
//

import Foundation
import UIKit

extension NSDirectionalEdgeInsets {
    init(uniform inset: CGFloat) {
        self.init(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}
