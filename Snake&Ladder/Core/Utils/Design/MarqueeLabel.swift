//
//  MarqueeLabel.swift
//  ClubLink_iOS
//
//  Created by SPURGE on 08/11/24.
//

import Foundation


import UIKit




@IBDesignable
class MarqueeLabel: UILabel {
	
	private var scrollView: UIView!
	private var textLabel: UILabel!
	
	// Allows animation duration to be set in Interface Builder
	@IBInspectable var animationDuration: TimeInterval = 6.0 {
		didSet {
			updateLabel()
		}
	}
	
	override var text: String? {
		didSet {
			updateLabel()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		// Set up the scroll view and the text label
		scrollView = UIView()
		textLabel = UILabel()
		textLabel.textColor = self.textColor
		textLabel.font = self.font
		
		scrollView.addSubview(textLabel)
		addSubview(scrollView)
		
		clipsToBounds = true
	}
	
	private func updateLabel() {
		guard let text = text else { return }
		
		// Set the text and size of the textLabel
		textLabel.text = text
		textLabel.sizeToFit()
		
		// Reset the frame of the scrollView and textLabel
		scrollView.frame = bounds
		textLabel.frame = CGRect(x: 0, y: 0, width: textLabel.bounds.width, height: bounds.height)
		
		// Check if text width exceeds label width, start animation if necessary
		if textLabel.bounds.width > bounds.width {
			startScrollingAnimation()
		} else {
			stopScrollingAnimation()
		}
	}
	
	private func startScrollingAnimation() {
		// Restart animation from the beginning
		textLabel.frame.origin.x = 0
		
		UIView.animate(withDuration: animationDuration, delay: 0.5, options: [.curveLinear, .repeat], animations: {
			self.textLabel.frame.origin.x = -self.textLabel.bounds.width
		}, completion: nil)
	}
	
	private func stopScrollingAnimation() {
		// Stop the animation
		textLabel.layer.removeAllAnimations()
		textLabel.frame.origin.x = 0
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		updateLabel()
	}
}


//
//@IBDesignable
//class MarqueeLabel: UILabel {
//	
//	private var scrollView: UIView!
//	private var textLabel: UILabel!
//	private var animationDuration: TimeInterval = 6.0  // Duration of the scroll animation
//	
//	override var text: String? {
//		didSet {
//			updateLabel()
//		}
//	}
//	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		setup()
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		setup()
//	}
//	
//	private func setup() {
//		// Set up the scroll view and the text label
//		scrollView = UIView()
//		textLabel = UILabel()
//		textLabel.textColor = self.textColor
//		textLabel.font = self.font
//		
//		scrollView.addSubview(textLabel)
//		addSubview(scrollView)
//		
//		clipsToBounds = true
//	}
//	
//	private func updateLabel() {
//		guard let text = text else { return }
//		
//		// Set the text and size of the textLabel
//		textLabel.text = text
//		textLabel.sizeToFit()
//		
//		// Reset the frame of the scrollView and textLabel
//		scrollView.frame = bounds
//		textLabel.frame = CGRect(x: 0, y: 0, width: textLabel.bounds.width, height: bounds.height)
//		
//		// Check if text width exceeds label width, start animation if necessary
//		if textLabel.bounds.width > bounds.width {
//			startScrollingAnimation()
//		} else {
//			stopScrollingAnimation()
//		}
//	}
//	
//	private func startScrollingAnimation() {
//		// Restart animation from the beginning
//		textLabel.frame.origin.x = 0
//		
//		UIView.animate(withDuration: animationDuration, delay: 0.5, options: [.curveLinear, .repeat], animations: {
//			self.textLabel.frame.origin.x = -self.textLabel.bounds.width
//		}, completion: nil)
//	}
//	
//	private func stopScrollingAnimation() {
//		// Stop the animation
//		textLabel.layer.removeAllAnimations()
//		textLabel.frame.origin.x = 0
//	}
//	
//	override func layoutSubviews() {
//		super.layoutSubviews()
//		updateLabel()
//	}
//}
