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
    
    private let primaryStart = UIColor(red: 0.90, green: 0.83, blue: 0.62, alpha: 1.0)
    private let primaryEnd   = UIColor(red: 0.84, green: 0.75, blue: 0.53, alpha: 1.0)
    private let altStart     = UIColor(red: 0.87, green: 0.79, blue: 0.58, alpha: 1.0)
    private let altEnd       = UIColor(red: 0.81, green: 0.72, blue: 0.49, alpha: 1.0)
    
    
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
    
    func configure(number: Int, isAlternate: Bool) {
        num_Lbl.text = String(format: "%02d", number)
        bg_View.startColor = isAlternate ? altStart : primaryStart
        bg_View.endColor = isAlternate ? altEnd : primaryEnd
    }
}
