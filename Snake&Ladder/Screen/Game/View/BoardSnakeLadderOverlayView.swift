//
//  BoardSnakeLadderOverlayView.swift
//  Snake&Ladder
//

import UIKit

final class BoardSnakeLadderOverlayView: UIView {

    var gridSpacing: CGFloat = 0
    var snakes: [Int: Int] = [:]
    var ladders: [Int: Int] = [:]
    /// Optional remapping when asset folder names differ from logical snake coordinates.
    /// key format: "head_tail", value format: "snake_<head>_<tail>"
    var snakeAssetAliases: [String: String] = [:]

    private var snakeImageViews: [UIImageView] = []

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
        isUserInteractionEnabled = false
    }

    func reloadData() {
        snakeImageViews.forEach { $0.removeFromSuperview() }
        snakeImageViews.removeAll()
        setNeedsLayout()
        setNeedsDisplay()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0, bounds.height > 0 else { return }

        snakeImageViews.forEach { $0.removeFromSuperview() }
        snakeImageViews.removeAll()

        for (head, tail) in snakes {
            placeSnakeImage(head: head, tail: tail)
        }
    }

    private func placeSnakeImage(head: Int, tail: Int) {
        let defaultName = "snake_\(head)_\(tail)"
        let imageName = snakeAssetAliases["\(head)_\(tail)"] ?? defaultName

        guard let image = UIImage(named: imageName) else {
            print("⚠️ Missing snake asset: \(imageName)")
            return
        }

        let headPt = cellCenter(head)
        let tailPt = cellCenter(tail)

        let dx = tailPt.x - headPt.x
        let dy = tailPt.y - headPt.y
        let distance = hypot(dx, dy)
        guard distance > 0 else { return }

        let cellW = (bounds.width - gridSpacing * 9) / 10

        // 🔥 IMPORTANT: Use FIXED width (not aspect ratio)
        let imgW = cellW * 1.1
        let imgH = distance

        let iv = UIImageView(image: image)

        // ❌ Don't use aspectFit here
        // ✅ Use fill for exact mapping
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = false

        // 🔥 Anchor at head
        iv.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        iv.bounds = CGRect(x: 0, y: 0, width: imgW, height: imgH)
//        iv.center = headPt
        iv.center = CGPoint(x: headPt.x, y: headPt.y + 2)

        let angle = atan2(dy, dx) - (.pi / 2)
        iv.transform = CGAffineTransform(rotationAngle: angle)

        addSubview(iv)
        snakeImageViews.append(iv)
    }

    // MARK: - Draw (ladders only)

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        for (start, end) in ladders.sorted(by: { $0.key < $1.key }) {
            drawLadder(
                from: cellCenter(start),
                to:   cellCenter(end),
                context: ctx
            )
        }
    }

    // MARK: - Cell Centre

    private func cellCenter(_ number: Int) -> CGPoint {
        let rowFromBottom = (number - 1) / 10
        let offsetInRow   = (number - 1) % 10
        let col           = rowFromBottom % 2 == 0 ? offsetInRow : 9 - offsetInRow
        let rowTop        = 9 - rowFromBottom

        let cellW = (bounds.width  - gridSpacing * 9) / 10
        let cellH = (bounds.height - gridSpacing * 9) / 10

        let x = CGFloat(col)    * (cellW + gridSpacing) + cellW / 2
        let y = CGFloat(rowTop) * (cellH + gridSpacing) + cellH / 2

        return CGPoint(x: x, y: y)
    }

    // MARK: - Ladder Drawing

    private func drawLadder(from: CGPoint, to: CGPoint, context: CGContext) {
        let dx  = to.x - from.x
        let dy  = to.y - from.y
        let len = max(hypot(dx, dy), 1)

        // perpendicular offset for rails
        let px  = -dy / len * 6
        let py  =  dx / len * 6

        context.saveGState()
        context.setLineCap(.round)

        // 🔶 Rails (thicker like reference)
        context.setStrokeColor(
            UIColor(red: 0.42, green: 0.28, blue: 0.12, alpha: 0.95).cgColor
        )
        context.setLineWidth(2)

        context.move(to: CGPoint(x: from.x + px, y: from.y + py))
        context.addLine(to: CGPoint(x: to.x + px, y: to.y + py))

        context.move(to: CGPoint(x: from.x - px, y: from.y - py))
        context.addLine(to: CGPoint(x: to.x - px, y: to.y - py))

        context.strokePath()

        // 🔶 Auto-calculated rungs
        let spacing: CGFloat = 18
        let rungs = max(3, Int(len / spacing))

        context.setStrokeColor(
            UIColor(red: 0.55, green: 0.4, blue: 0.2, alpha: 0.9).cgColor
        )
        context.setLineWidth(3.5)

        for i in 1..<rungs {
            let t  = CGFloat(i) / CGFloat(rungs)
            let bx = from.x + dx * t
            let by = from.y + dy * t

            context.move(to: CGPoint(x: bx + px, y: by + py))
            context.addLine(to: CGPoint(x: bx - px, y: by - py))
        }

        context.strokePath()
        context.restoreGState()
    }
}
