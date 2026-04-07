//
//  UILabelDesignable.swift
//  ClubLink_iOS
//
//  Created by SPURGE on 02/01/25.
//

import UIKit

@IBDesignable
final class UILabelDesignable: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    @IBInspectable var masksToBounds: Bool = false{
        didSet { layer.masksToBounds = masksToBounds }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { layer.shadowRadius = shadowRadius }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet { layer.shadowOpacity = shadowOpacity }
    }
    
    @IBInspectable var shadow_Offset: CGSize = .init(width: 0, height: 0) {
        didSet { layer.shadowOffset = shadow_Offset }
    }
    
    @IBInspectable var shadow_Color: UIColor = .clear {
        didSet { layer.shadowColor = shadow_Color.cgColor }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.masksToBounds = false
//    }
}

import UIKit

@IBDesignable
class CorneredLabel: UILabel {
    

}
