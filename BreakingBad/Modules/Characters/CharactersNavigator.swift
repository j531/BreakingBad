//
//  CharactersNavigator.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 22/11/2020.
//

import Foundation
import UIKit

protocol CharactersNavigation {
    func pushDetails(for character: Character)
}

class CharactersNavigator: CharactersNavigation {

    // MARK: - Public properties

    weak var viewController: UIViewController? = nil

    // MARK: - Routes

    func pushDetails(for character: Character) {
        // CharacterDetailsBuilder.build() etc...
        let controller = UIViewController()
        controller.title = character.name
        controller.view.backgroundColor = .white
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
