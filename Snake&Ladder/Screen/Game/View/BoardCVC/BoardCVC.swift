//
//  BoardCVC.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 01/04/26.
//

import UIKit

class BoardCVC: UICollectionViewCell {
    
    @IBOutlet weak var bg_View: GradientView!
    @IBOutlet weak var num_Lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        num_Lbl.font = .systemFont(ofSize: 11, weight: .semibold)
//        num_Lbl.textColor = UIColor(white: 0.25, alpha: 1)
//        bg_View.cornerRadius = 6
        
        num_Lbl.font = .systemFont(ofSize: 11, weight: .semibold)
                num_Lbl.textColor = UIColor(white: 0.25, alpha: 1)
                num_Lbl.adjustsFontSizeToFitWidth = true
                num_Lbl.minimumScaleFactor = 0.4
                num_Lbl.numberOfLines = 1
                num_Lbl.lineBreakMode = .byClipping   // prevents "..." truncation
                bg_View.cornerRadius = 4      
    }
    
    func configure(number: Int) {
        num_Lbl.text = String(format: "%02d", number)
    }
}
