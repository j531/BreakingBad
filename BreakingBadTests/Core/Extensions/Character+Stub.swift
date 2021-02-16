//
//  Character+Stub.swift
//  BreakingBadTests
//
//  Created by Joshua Simmons on 02/12/2020.
//

import Foundation
@testable import BreakingBad

extension Character {
    static func makeStub(id: Int = 0, name: String = "Test", imageURL:String = "http://www.google.com") -> Character {
        .init(id: id, name: name, imageURL: imageURL)
    }
}
