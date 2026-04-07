//
//  UIViewDesignable.swift
//  Jakson_Cus_iOS
//
//  Created by admin on 05/06/24.
//

import UIKit

@IBDesignable
class UIViewDesignable: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { layer.shadowRadius = shadowRadius }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet { layer.shadowOpacity = shadowOpacity }
    }
    
    @IBInspectable var shadowOffset: CGSize = .init(width: 0, height: 0) {
        didSet { layer.shadowOffset = shadowOffset }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet { layer.shadowColor = shadowColor.cgColor }
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

@IBDesignable
class UIViewMaskedCornersDesignable: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { updateMask() }
    }
    @IBInspectable var topLeft: Bool = false {
        didSet { updateMask() }
    }
    @IBInspectable var topRight: Bool = false { 
        didSet { updateMask() }
    }
    @IBInspectable var bottomLeft: Bool = false {
        didSet { updateMask() }
    }
    @IBInspectable var bottomRight: Bool = false {
        didSet { updateMask() }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { layer.shadowRadius = shadowRadius }
    }
    @IBInspectable var shadowOpacity: Float = 0 { 
        didSet { layer.shadowOpacity = shadowOpacity }
    }
    @IBInspectable var shadowOffset: CGSize = .zero { 
        didSet { layer.shadowOffset = shadowOffset }
    }
    @IBInspectable var shadowColor: UIColor = .clear { 
        didSet { layer.shadowColor = shadowColor.cgColor }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    @IBInspectable var borderWidth: CGFloat = 0 { 
        didSet { layer.borderWidth = borderWidth }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateMask()
    }
    
    private func updateMask() {
        var maskedCorners: CACornerMask = []
        if topLeft { maskedCorners.insert(.layerMinXMinYCorner) }
        if topRight { maskedCorners.insert(.layerMaxXMinYCorner) }
        if bottomLeft { maskedCorners.insert(.layerMinXMaxYCorner) }
        if bottomRight { maskedCorners.insert(.layerMaxXMaxYCorner) }
        
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        layer.masksToBounds = false
    }
}

//
//  UIViewDesignable.swift
//  Jakson_Cus_iOS
//
//  Created by admin on 05/06/24.
//

import UIKit

@IBDesignable
class UIStackDesignable: UIStackView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { layer.shadowRadius = shadowRadius }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet { layer.shadowOpacity = shadowOpacity }
    }
    
    @IBInspectable var shadowOffset: CGSize = .init(width: 0, height: 0) {
        didSet { layer.shadowOffset = shadowOffset }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet { layer.shadowColor = shadowColor.cgColor }
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

@IBDesignable
class UIStackMaskedCornersDesignable: UIStackView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { updateMask() }
    }
    @IBInspectable var topLeft: Bool = false {
        didSet { updateMask() }
    }
    @IBInspectable var topRight: Bool = false {
        didSet { updateMask() }
    }
    @IBInspectable var bottomLeft: Bool = false {
        didSet { updateMask() }
    }
    @IBInspectable var bottomRight: Bool = false {
        didSet { updateMask() }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet { layer.shadowRadius = shadowRadius }
    }
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet { layer.shadowOpacity = shadowOpacity }
    }
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet { layer.shadowOffset = shadowOffset }
    }
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet { layer.shadowColor = shadowColor.cgColor }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateMask()
    }
    
    private func updateMask() {
        var maskedCorners: CACornerMask = []
        if topLeft { maskedCorners.insert(.layerMinXMinYCorner) }
        if topRight { maskedCorners.insert(.layerMaxXMinYCorner) }
        if bottomLeft { maskedCorners.insert(.layerMinXMaxYCorner) }
        if bottomRight { maskedCorners.insert(.layerMaxXMaxYCorner) }
        
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
        layer.masksToBounds = false
    }
}
