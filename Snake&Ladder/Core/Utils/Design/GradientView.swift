
//
//  GradientView.swift
//  Jakson_Cus_iOS
//
//  Created by admin on 05/06/24.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    // MARK: - Gradient Properties
    
    @IBInspectable var startColor: UIColor = .black {
        didSet { updateColors() }
    }
    
    @IBInspectable var endColor: UIColor = .white {
        didSet { updateColors() }
    }
    
    @IBInspectable var startLocation: Double = 0.0 {
        didSet { updateLocations() }
    }
    
    @IBInspectable var endLocation: Double = 1.0 {
        didSet { updateLocations() }
    }
    
    @IBInspectable var horizontalMode: Bool = false {
        didSet { updatePoints() }
    }
    
    @IBInspectable var diagonalMode: Bool = false {
        didSet { updatePoints() }
    }

    // MARK: - Border Properties
    
    private let borderLayer = CAShapeLayer()
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { updateBorder() }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { updateBorder() }
    }

    // MARK: - Corner Radius
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.masksToBounds = true

        updateBorder()
        updatePoints()
        updateLocations()
        updateColors()
    }

    // MARK: - Gradient Updates
    
    private func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }

    private func updateLocations() {
        gradientLayer.locations = [NSNumber(value: startLocation),
                                   NSNumber(value: endLocation)]
    }

    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor,
                                endColor.cgColor]
    }

    // MARK: - Border Update
    
    private func updateBorder() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds

        if borderLayer.superlayer == nil {
            layer.addSublayer(borderLayer)
        }
    }
}
