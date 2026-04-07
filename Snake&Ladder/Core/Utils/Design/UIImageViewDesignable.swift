//
//  UIImageViewDesignable.swift
//  Jakson_Cus_iOS
//
//  Created by admin on 05/06/24.
//

import UIKit

@IBDesignable
class UIImageViewDesignable: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { layer.borderColor = borderColor.cgColor }
    }
}
