//
//  SpyCharacterCollectionView.swift
//  BreakingBadTests
//
//  Created by Joshua Simmons on 02/12/2020.
//

import Foundation
@testable import BreakingBad

class SpyCharacterCollectionView: StateUpdatable {

    var invokedUpdate = false
    var invokedUpdateCount = 0
    var invokedUpdateParameters: (state: State, Void)?
    var invokedUpdateParametersList = [(state: State, Void)]()

    func update(with state: CharactersCollectionViewModel.State) {
        invokedUpdate = true
        invokedUpdateCount += 1
        invokedUpdateParameters = (state, ())
        invokedUpdateParametersList.append((state, ()))
    }
}
