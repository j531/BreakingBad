//
//  SpyCharactersWebService.swift
//  BreakingBadTests
//
//  Created by Joshua Simmons on 01/12/2020.
//

import Foundation
@testable import BreakingBad

class SpyCharactersWebService: CharactersWebService {

    var invokedGetCharacters = false
    var invokedGetCharactersCount = 0
    var stubbedGetCharactersHandlerResult: (Result<[Character], RequestError>, Void)?

    func getCharacters(then handler: @escaping (Result<[Character], RequestError>) -> Void) {
        invokedGetCharacters = true
        invokedGetCharactersCount += 1
        if let result = stubbedGetCharactersHandlerResult {
            handler(result.0)
        }
    }
}
