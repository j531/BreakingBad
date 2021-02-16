//
//  Character.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 20/11/2020.
//

import Foundation

struct Character: Decodable, Hashable {

    // MARK: - Public properties

    let id: Int
    let name: String
    let imageURL: String

    // MARK: - Keys

    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case imageURL = "img"
    }
}
