//
//  SpyCharactersNavigation.swift
//  BreakingBadTests
//
//  Created by Joshua Simmons on 01/12/2020.
//

import Foundation
@testable import BreakingBad

class SpyCharactersNavigation: CharactersNavigation {

    var invokedPushDetails = false
    var invokedPushDetailsCount = 0
    var invokedPushDetailsParameters: (character: Character, Void)?
    var invokedPushDetailsParametersList = [(character: Character, Void)]()

    func pushDetails(for character: Character) {
        invokedPushDetails = true
        invokedPushDetailsCount += 1
        invokedPushDetailsParameters = (character, ())
        invokedPushDetailsParametersList.append((character, ()))
    }
}
