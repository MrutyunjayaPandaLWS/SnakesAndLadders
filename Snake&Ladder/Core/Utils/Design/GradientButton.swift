//
//  GradientButton.swift
//  Jakson_Cus_iOS
//
//  Created by admin on 05/06/24.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {

    // MARK: - Inspectable Properties

    @IBInspectable var startColor: UIColor = .black {
        didSet { applyGradient() }
    }

    @IBInspectable var endColor: UIColor = .white {
        didSet { applyGradient() }
    }

    @IBInspectable var startLocation: Double = 0.0 {
        didSet { applyGradient() }
    }

    @IBInspectable var endLocation: Double = 1.0 {
        didSet { applyGradient() }
    }

    @IBInspectable var horizontalMode: Bool = false {
        didSet { applyGradient() }
    }

    @IBInspectable var diagonalMode: Bool = false {
        didSet { applyGradient() }
    }

    @IBInspectable var verticalMode: Bool = false {
        didSet { applyGradient() }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            gradientLayer?.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }

    // MARK: - Override Layer Class

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Gradient Layer

    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient()
    }

    // MARK: - Gradient Setup

    private func applyGradient() {
        guard let gradientLayer = gradientLayer else { return }

        // Colors
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]

        // Locations
        gradientLayer.locations = [
            NSNumber(value: startLocation),
            NSNumber(value: endLocation)
        ]

        // Direction
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode
                ? CGPoint(x: 1, y: 0)
                : CGPoint(x: 0, y: 0.5)

            gradientLayer.endPoint = diagonalMode
                ? CGPoint(x: 0, y: 1)
                : CGPoint(x: 1, y: 0.5)

        } else {
            gradientLayer.startPoint = diagonalMode
                ? CGPoint(x: 0, y: 0)
                : CGPoint(x: 0.5, y: 0)

            gradientLayer.endPoint = diagonalMode
                ? CGPoint(x: 1, y: 1)
                : CGPoint(x: 0.5, y: 1)
        }
    }

    // MARK: - Public API (Recommended Way)

    func setGradient(start: UIColor, end: UIColor) {
        self.startColor = start
        self.endColor = end
    }
}
