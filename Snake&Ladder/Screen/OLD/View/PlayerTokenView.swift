//
//  PlayerTokenView.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit

final class PlayerTokenView: UIView {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
