//
//  BoardOverlayView.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit

final class BoardOverlayView: UIView {
    
    var snakes: [Snake] = []
    var ladders: [Ladder] = []
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineWidth(4)
        
        // Draw ladders
        UIColor.brown.setStroke()
        ladders.forEach {
            context.move(to: point(for: $0.start))
            context.addLine(to: point(for: $0.end))
        }
        
        context.strokePath()
        
        // Draw snakes
        UIColor.red.setStroke()
        snakes.forEach {
            context.move(to: point(for: $0.head))
            context.addLine(to: point(for: $0.tail))
        }
        
        context.strokePath()
    }
    
    private func point(for index: Int) -> CGPoint {
        return CGPoint(x: 50, y: 50) // Replace with real mapping
    }
}
