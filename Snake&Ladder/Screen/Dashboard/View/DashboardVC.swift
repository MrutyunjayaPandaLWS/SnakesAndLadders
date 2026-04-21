//
//  DashboardVC.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 20/04/26.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var twoPlayer_Btn: UIButton!
    @IBOutlet weak var threePlayer_Btn: UIButton!
    @IBOutlet weak var fourPlayer_Btn: UIButton!
    @IBOutlet weak var versusAI_Btn: UIButton!
    
    var selectedGameMode: GameMode = .fourPlayer
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapTwoPlayerBtn(_ sender: UIButton){
        selectedGameMode = .twoPlayer
        navigateToGameVC()
    }
    
    @IBAction func didTapThreePlayerBtn(_ sender: UIButton){
        selectedGameMode = .threePlayer
        navigateToGameVC()
    }
    
    @IBAction func didTapFourPlayerBtn(_ sender: UIButton){
        selectedGameMode = .fourPlayer
        navigateToGameVC()
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
}


enum GameMode: Int {
    case twoPlayer, threePlayer, fourPlayer, versusAI
}
