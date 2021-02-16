//
//  CharactersBuilder.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 20/11/2020.
//

import Foundation
import UIKit

enum CharactersBuilder {

    // MARK: - Build
    
    static func build() -> UIViewController {
        let navigator = CharactersNavigator()
        let viewModel = CharactersCollectionViewModel(navigator: navigator, webService: CharactersHTTPService())
        let controller = CharactersCollectionViewController(viewModel: viewModel)

        navigator.viewController = controller
        viewModel.setView(controller)

        return controller
    }
}
