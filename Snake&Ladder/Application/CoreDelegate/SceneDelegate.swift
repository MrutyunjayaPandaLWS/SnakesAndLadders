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
        
        let players = [
            Player(id: 1, position: 0, color: .red),
            Player(id: 2, position: 0, color: .blue)
        ]
        
        let viewModel = GameViewModel(players: players)
//        let gameVC = GameVC(viewModel: viewModel)
        let gameVC = GameMainVC()
        
        let nav = UINavigationController(rootViewController: gameVC)
        
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }

   

}

