//
//  UISegmentControl.swift
//  Blum_Customer
//
//  Created by admin on 06/09/25.
//

import Foundation
import UIKit

@IBDesignable
class UISegmentedControlDesignable: UISegmentedControl {
    
    // MARK: - Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    // MARK: - Masked Corners (IBInspectable Booleans)
    @IBInspectable var topLeft: Bool = true { didSet { updateMaskedCorners() } }
    @IBInspectable var topRight: Bool = true { didSet { updateMaskedCorners() } }
    @IBInspectable var bottomLeft: Bool = true { didSet { updateMaskedCorners() } }
    @IBInspectable var bottomRight: Bool = true { didSet { updateMaskedCorners() } }
    
    // MARK: - Shadow
    @IBInspectable var shadowRadius: CGFloat = 4 {
        didSet { layer.shadowRadius = shadowRadius }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet { layer.shadowOpacity = shadowOpacity }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet { layer.shadowOffset = shadowOffset }
    }
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet { layer.shadowColor = shadowColor.cgColor }
    }
    
    // MARK: - Border
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
   
    
    private func updateMaskedCorners() {
        var corners: CACornerMask = []
        if topLeft { corners.insert(.layerMinXMinYCorner) }
        if topRight { corners.insert(.layerMaxXMinYCorner) }
        if bottomLeft { corners.insert(.layerMinXMaxYCorner) }
        if bottomRight { corners.insert(.layerMaxXMaxYCorner) }
        layer.maskedCorners = corners
    }
    
    // MARK: - Setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        
        updateMaskedCorners()
    }
}
