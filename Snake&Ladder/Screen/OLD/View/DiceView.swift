//
//  DiceView.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit

final class DiceView: UIButton {
    
    func roll(completion: @escaping (Int) -> Void) {
        let value = Int.random(in: 1...6)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            self.transform = .identity
            completion(value)
        }
    }
}
