//
//  BoardSnakeLadderOverlayView.swift
//  Snake&Ladder
//

import UIKit

/// Renders snakes and ladders on the 10×10 grid (same cell math as `GameMainVC`).
/// Sits above the collection view; pawns should be added after this view so they stay on top.
final class BoardSnakeLadderOverlayView: UIView {
    
    /// Keep in sync with `GameMainVC` / flow layout (0 = cells tile edge-to-edge).
    var gridSpacing: CGFloat = 0
    var snakes: [Int: Int] = [:]
    var ladders: [Int: Int] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        isOpaque = false
        backgroundColor = .clear
        contentMode = .redraw
        isUserInteractionEnabled = false
    }
    
    func reloadData() {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        for (start, end) in ladders.sorted(by: { $0.key < $1.key }) {
            drawLadder(from: cellCenter(start, in: rect), to: cellCenter(end, in: rect), context: ctx)
        }
        for (head, tail) in snakes.sorted(by: { $0.key < $1.key }) {
            drawSnake(from: cellCenter(head, in: rect), to: cellCenter(tail, in: rect), context: ctx)
        }
    }
    
    private func cellCenter(_ number: Int, in rect: CGRect) -> CGPoint {
        let rowFromBottom = (number - 1) / 10
        let offsetInRow = (number - 1) % 10
        let col = rowFromBottom % 2 == 0 ? offsetInRow : 9 - offsetInRow
        let rowTop = 9 - rowFromBottom
        let side = (rect.width - gridSpacing * 9) / 10
        let x = CGFloat(col) * (side + gridSpacing) + side / 2
        let y = CGFloat(rowTop) * (side + gridSpacing) + side / 2
        return CGPoint(x: x, y: y)
    }
    
    private func drawLadder(from: CGPoint, to: CGPoint, context: CGContext) {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let len = max(hypot(dx, dy), 1)
        let ux = dx / len
        let uy = dy / len
        let px = -uy * 5
        let py = ux * 5
        
        context.saveGState()
        context.setStrokeColor(UIColor(red: 0.42, green: 0.28, blue: 0.12, alpha: 0.95).cgColor)
        context.setLineWidth(2.5)
        context.setLineCap(.round)
        context.move(to: CGPoint(x: from.x + px, y: from.y + py))
        context.addLine(to: CGPoint(x: to.x + px, y: to.y + py))
        context.move(to: CGPoint(x: from.x - px, y: from.y - py))
        context.addLine(to: CGPoint(x: to.x - px, y: to.y - py))
        context.strokePath()
        
        let rungs = 6
        context.setStrokeColor(UIColor(red: 0.55, green: 0.4, blue: 0.2, alpha: 0.9).cgColor)
        context.setLineWidth(2)
        for i in 1..<rungs {
            let t = CGFloat(i) / CGFloat(rungs)
            let bx = from.x + dx * t
            let by = from.y + dy * t
            context.move(to: CGPoint(x: bx + px, y: by + py))
            context.addLine(to: CGPoint(x: bx - px, y: by - py))
        }
        context.strokePath()
        context.restoreGState()
    }
    
    private func drawSnake(from: CGPoint, to: CGPoint, context: CGContext) {
        let path = curvedSnakePath(from: from, to: to)
        context.saveGState()
        context.setStrokeColor(UIColor(red: 0.78, green: 0.18, blue: 0.22, alpha: 0.95).cgColor)
        context.setLineWidth(5)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.addPath(path.cgPath)
        context.strokePath()
        context.setFillColor(UIColor(red: 0.92, green: 0.32, blue: 0.38, alpha: 1).cgColor)
        context.fillEllipse(in: CGRect(x: from.x - 7, y: from.y - 7, width: 14, height: 14))
        context.setStrokeColor(UIColor.white.withAlphaComponent(0.35).cgColor)
        context.setLineWidth(1)
        context.strokeEllipse(in: CGRect(x: from.x - 7, y: from.y - 7, width: 14, height: 14))
        context.restoreGState()
    }
    
    private func curvedSnakePath(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: from)
        let dx = to.x - from.x
        let dy = to.y - from.y
        let len = max(hypot(dx, dy), 1)
        let nx = -dy / len * 26
        let ny = dx / len * 26
        let c1 = CGPoint(x: (from.x * 2 + to.x) / 3 + nx * 0.65, y: (from.y * 2 + to.y) / 3 + ny * 0.65)
        let c2 = CGPoint(x: (from.x + to.x * 2) / 3 - nx * 0.65, y: (from.y + to.y * 2) / 3 - ny * 0.65)
        path.addCurve(to: to, controlPoint1: c1, controlPoint2: c2)
        return path
    }
}
