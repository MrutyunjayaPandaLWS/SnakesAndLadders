//
//  DashboardVC.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 20/04/26.
//

import UIKit

class DashboardVC: UIViewController {

   
    @IBOutlet weak var exit_Btn: UIButton!
    @IBOutlet weak var playWithfrnds_Btn: UIButton!
    @IBOutlet weak var versusAI_Btn: UIButton!
    
    var selectedGameMode: GameMode = .versusAI
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapExitBtn(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapPlayWithFrndsBtn(_ sender: UIButton){
        navigateToSelectPlayerVC()
    }
    
    @IBAction func didTapVersusAIBtn(_ sender: UIButton){
        selectedGameMode = .versusAI
        navigateToGameVC()
    }

}


extension DashboardVC{
    func navigateToGameVC(){
        let vc = GameMainVC()
        vc.gameMode = selectedGameMode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSelectPlayerVC(){
        let vc = SelectPlayersVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


enum GameMode: Int {
    case twoPlayer, threePlayer, fourPlayer, versusAI
}
