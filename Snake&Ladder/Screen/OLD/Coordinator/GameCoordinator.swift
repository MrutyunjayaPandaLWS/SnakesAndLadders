//
//  GameCoordinator.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit

final class GameCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let players = [
            Player(id: 1, position: 0, color: .red),
            Player(id: 2, position: 0, color: .blue)
        ]
        
        let vm = GameViewModel(players: players)
        let vc = GameVC(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: true)
    }
}
