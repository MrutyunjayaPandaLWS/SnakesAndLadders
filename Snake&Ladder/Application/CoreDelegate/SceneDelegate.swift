//
//  SceneDelegate.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let gameVC = DashboardVC()
        
        let nav = UINavigationController(rootViewController: gameVC)
        
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }

   

}

