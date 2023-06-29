//
//  SceneDelegate.swift
//  FeedScroll
//
//  Created by Владимир Коваленко on 27.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: winScene.coordinateSpace.bounds)
        window?.windowScene = winScene
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
    }
}

