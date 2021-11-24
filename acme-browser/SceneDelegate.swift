//
//  SceneDelegate.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 10/20/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dependencies = AppDependencies()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        dependencies.installRootViewControllerIntoWindow(window: window)
    }

}

