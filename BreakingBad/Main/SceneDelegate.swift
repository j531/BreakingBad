//
//  SceneDelegate.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 18/11/2020.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Public properties

    var window: UIWindow?

    // MARK: - Entry

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let characterController = CharactersBuilder.build()
        window?.rootViewController = UINavigationController(rootViewController: characterController)
        window?.makeKeyAndVisible()
    }
}
