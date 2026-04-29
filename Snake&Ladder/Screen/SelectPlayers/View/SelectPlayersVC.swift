//
//  SelectPlayersVC.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 29/04/26.
//

import UIKit

class SelectPlayersVC: UIViewController {
    
    
    @IBOutlet weak var home_Btn: UIButton!
    @IBOutlet weak var selectPlayers_Lbl: UILabel!
    @IBOutlet weak var twoPlayerImgBg_View: UIView!
    @IBOutlet weak var twoPlayer_Lbl: UILabel!
    @IBOutlet weak var twoPlayer_Btn: UIButton!
    @IBOutlet weak var threePlayerImgBg_View: UIView!
    @IBOutlet weak var threePlayer_Lbl: UILabel!
    @IBOutlet weak var threePlayer_Btn: UIButton!
    @IBOutlet weak var fourPlayerImgBg_View: UIView!
    @IBOutlet weak var fourPlayer_Lbl: UILabel!
    @IBOutlet weak var fourPlayer_Btn: UIButton!
    @IBOutlet weak var play_Btn: UIButton!

    var selectedGameMode: GameMode = .twoPlayer
 
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSelectionUI(for: selectedGameMode)
    }
    
    @IBAction func didTapHomeBtn(_ sender: UIButton){
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func didTapPlayTwoPlayerBtn(_ sender: UIButton){
       updateSelectionUI(for: .twoPlayer)
        
    }
    
    @IBAction func didTapThreePlayerBtn(_ sender: UIButton){
        updateSelectionUI(for: .threePlayer)
    }
    
    @IBAction func didTapFourPlayerBtn(_ sender: UIButton){
        updateSelectionUI(for: .fourPlayer)
    }

    @IBAction func didTapPlayBtn(_ sender: UIButton){
        navigateToGameVC()
    }

}


extension SelectPlayersVC{
    func updateSelectionUI(for mode: GameMode){
        selectedGameMode = mode
        
        let views: [(UIView, UILabel, GameMode)] = [
            (twoPlayerImgBg_View, twoPlayer_Lbl, .twoPlayer),
            (threePlayerImgBg_View, threePlayer_Lbl, .threePlayer),
            (fourPlayerImgBg_View, fourPlayer_Lbl, .fourPlayer),
        ]
        
        views.forEach { view, label, currentMode in
            if currentMode == mode{
                view.backgroundColor = AppColor.teriary
                label.textColor = .white
            }else{
                view.backgroundColor = AppColor.primary
                label.textColor = .tertiary
            }
        }
    }
}

extension SelectPlayersVC{
    func navigateToGameVC(){
        let vc = GameMainVC()
        vc.gameMode = selectedGameMode
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
