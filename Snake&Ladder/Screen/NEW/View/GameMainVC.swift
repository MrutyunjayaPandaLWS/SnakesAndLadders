//
//  GameMainVC.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 01/04/26.
//

import UIKit
import SwiftyGif

class GameMainVC: UIViewController {
    
    @IBOutlet weak var mainBg_imgView: UIImageView!
    @IBOutlet weak var playersTurn_Lbl: UILabel!
    
    @IBOutlet weak var p1Main_View: UIViewDesignable!
    @IBOutlet weak var p1DiceBg_View: UIViewDesignable!
    @IBOutlet weak var p1Dice_ImgView: UIImageView!
    @IBOutlet weak var p1Dice_Btn: UIButton!
    @IBOutlet weak var p1Title_Lbl: UILabel!
    
    @IBOutlet weak var p2Main_View: UIViewDesignable!
    @IBOutlet weak var p2DiceBg_View: UIViewDesignable!
    @IBOutlet weak var p2Dice_ImgView: UIImageView!
    @IBOutlet weak var p2Dice_Btn: UIButton!
    @IBOutlet weak var p2Title_Lbl: UILabel!
    
    @IBOutlet weak var p3Main_View: UIViewDesignable!
    @IBOutlet weak var p3DiceBg_View: UIViewDesignable!
    @IBOutlet weak var p3Dice_ImgView: UIImageView!
    @IBOutlet weak var p3Dice_Btn: UIButton!
    @IBOutlet weak var p3Title_Lbl: UILabel!
    
    @IBOutlet weak var p4Main_View: UIViewDesignable!
    @IBOutlet weak var p4DiceBg_View: UIViewDesignable!
    @IBOutlet weak var p4Dice_ImgView: UIImageView!
    @IBOutlet weak var p4Dice_Btn: UIButton!
    @IBOutlet weak var p4Title_Lbl: UILabel!
    
    @IBOutlet weak var boardBg_View: UIViewDesignable!
    @IBOutlet weak var board_CV: UICollectionView!
    
    private let snakeLadderOverlay = BoardSnakeLadderOverlayView()
    // MARK: - Game State
    
    var currentPlayerIndex = 0
    var playerPositions = [1, 1, 1, 1]
    var playerTokens: [UIView] = []
    private var gameFinished = false
    
    /// Must match UICollectionViewFlowLayout spacing (contiguous cells, no gaps).
    private let gridSpacing: CGFloat = 0
    
    /// Prevents viewDidLayoutSubviews from snapping pawns back while a move is animating.
    private var isAnimatingMove = false
    
    /// Last completed dice value per player.
    private var lastDiceRoll: [Int?] = [1, 2, nil, nil]
    private var diceResultLabels: [UILabel] = []
    
    /// Head → tail (matches reference board)
    let snakes: [Int: Int] = [
        83: 2,
        62: 42,
        86: 72,
        54: 44,
        32: 8
    ]
    
    let ladders: [Int: Int] = [
        5: 23,
        14: 56,
        31: 51,
        44: 77,
        60: 82,
        73: 93
    ]
    
    private var didInitialLayout = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersTurn_Lbl.textColor = .white
        playersTurn_Lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        
        board_CV.backgroundColor = .clear
        board_CV.isScrollEnabled = false
        if let layout = board_CV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.sectionInset = .zero
        }
        
        setupCollectionView()
        setupSnakeLadderOverlay()
        setupPlayerAvatars()
        setupDiceResultLabels()
        setupTokens()           // tokens added + bringSubviewToFront done here once
        updateActivePlayerUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        snakeLadderOverlay.gridSpacing = gridSpacing
        snakeLadderOverlay.snakes = snakes
        snakeLadderOverlay.ladders = ladders
        snakeLadderOverlay.reloadData()
        
        if !didInitialLayout && board_CV.bounds.width > 0 {
            didInitialLayout = true
            board_CV.reloadData()
        }
        
        // FIX: Only snap tokens when no animation is running AND layout is stable.
        // Removed bringSubviewToFront from here — it was triggering extra layout
        // passes and causing visible pawn jumps during animation.
        if !isAnimatingMove && didInitialLayout {
            layoutTokensAtCurrentPositions()
        }
    }
        
        // MARK: - IBActions
    @IBAction func didTapP1DiceBtn(_ sender: UIButton) {
        handleDiceRoll(for: 0, imageView: p1Dice_ImgView)
    }
    
    @IBAction func didTapP2DiceBtn(_ sender: UIButton) {
        handleDiceRoll(for: 1, imageView: p2Dice_ImgView)
    }
    
    @IBAction func didTapP3DiceBtn(_ sender: UIButton) {
        handleDiceRoll(for: 2, imageView: p3Dice_ImgView)
    }
    
    @IBAction func didTapP4DiceBtn(_ sender: UIButton) {
        handleDiceRoll(for: 3, imageView: p4Dice_ImgView)
    }
    
}

// MARK: - Setup

extension GameMainVC {
    
    func setupSnakeLadderOverlay() {
        snakeLadderOverlay.translatesAutoresizingMaskIntoConstraints = false
        snakeLadderOverlay.gridSpacing = gridSpacing
        snakeLadderOverlay.snakes = snakes
        snakeLadderOverlay.ladders = ladders
        boardBg_View.insertSubview(snakeLadderOverlay, aboveSubview: board_CV)
        NSLayoutConstraint.activate([
            snakeLadderOverlay.leadingAnchor.constraint(equalTo: board_CV.leadingAnchor),
            snakeLadderOverlay.trailingAnchor.constraint(equalTo: board_CV.trailingAnchor),
            snakeLadderOverlay.topAnchor.constraint(equalTo: board_CV.topAnchor),
            snakeLadderOverlay.bottomAnchor.constraint(equalTo: board_CV.bottomAnchor)
        ])
        snakeLadderOverlay.reloadData()
    }
    
    func setupPlayerAvatars() {
        let views = [p1Dice_ImgView, p2Dice_ImgView, p3Dice_ImgView, p4Dice_ImgView]
        for (i, iv) in views.enumerated() {
            iv?.image = UIImage(named: "player\(i + 1)")
            iv?.contentMode = .scaleAspectFill
            iv?.clipsToBounds = true
        }
    }
    
    func setupDiceResultLabels() {
        let diceBgs: [UIView?] = [p1DiceBg_View, p2DiceBg_View, p3DiceBg_View, p4DiceBg_View]
        let diceButtons: [UIButton?] = [p1Dice_Btn, p2Dice_Btn, p3Dice_Btn, p4Dice_Btn]
        diceResultLabels = []
        for i in 0..<4 {
            guard let container = diceBgs[i] else { continue }
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = .systemFont(ofSize: 28, weight: .bold)
            lbl.textColor = .white
            lbl.textAlignment = .center
            lbl.isUserInteractionEnabled = false
            lbl.layer.shadowColor = UIColor.black.cgColor
            lbl.layer.shadowOffset = CGSize(width: 0, height: 1)
            lbl.layer.shadowRadius = 2
            lbl.layer.shadowOpacity = 0.4
            if let btn = diceButtons[i] {
                container.insertSubview(lbl, belowSubview: btn)
            } else {
                container.addSubview(lbl)
            }
            NSLayoutConstraint.activate([
                lbl.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                lbl.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            diceResultLabels.append(lbl)
        }
    }
    
    func setupTokens() {
        let colors: [UIColor] = [
            UIColor(red: 0.92, green: 0.22, blue: 0.22, alpha: 1),    // Red
            UIColor(red: 0.18, green: 0.45, blue: 0.92, alpha: 1),    // Blue
            UIColor(red: 0.98, green: 0.82, blue: 0.22, alpha: 1),    // Yellow
            UIColor(red: 0.18, green: 0.78, blue: 0.34, alpha: 1)     // Green
        ]
        for i in 0..<4 {
            let pawn = PawnView(color: colors[i])
            pawn.bounds = CGRect(x: 0, y: 0, width: 22, height: 28)
            boardBg_View.addSubview(pawn)
            playerTokens.append(pawn)
        }
        // FIX: bringSubviewToFront done once here at setup, NOT in viewDidLayoutSubviews.
        // Calling it in viewDidLayoutSubviews was triggering extra layout passes,
        // causing pawn positions to snap/jump mid-animation.
        boardBg_View.bringSubviewToFront(snakeLadderOverlay)
        playerTokens.forEach { boardBg_View.bringSubviewToFront($0) }
    }
}

// MARK: - UI Updates

extension GameMainVC {
    
    /// Shows last dice for inactive players; hides during the active player's roll until value is known.
    func updateDiceRollDisplay() {
        guard diceResultLabels.count == 4 else { return }
        for i in 0..<4 {
            let active = i == currentPlayerIndex && !gameFinished
            let value = lastDiceRoll[i]
            let showNumber: Bool
            if let v = value {
                if active {
                    showNumber = isAnimatingMove
                } else {
                    showNumber = true
                }
                diceResultLabels[i].text = "\(v)"
            } else {
                showNumber = false
                diceResultLabels[i].text = nil
            }
            diceResultLabels[i].isHidden = !showNumber
        }
    }
    
    func updateActivePlayerUI() {
        let mains = [p1Main_View, p2Main_View, p3Main_View, p4Main_View]
        let diceButtons = [p1Dice_Btn, p2Dice_Btn, p3Dice_Btn, p4Dice_Btn]
        let diceImages = [p1Dice_ImgView, p2Dice_ImgView, p3Dice_ImgView, p4Dice_ImgView]
        for i in 0..<4 {
            let active = i == currentPlayerIndex && !gameFinished
            mains[i]?.layer.borderWidth = active ? 3 : 0
            mains[i]?.layer.borderColor = UIColor(red: 1, green: 0.85, blue: 0.2, alpha: 1).cgColor
            mains[i]?.layer.cornerRadius = 8
            mains[i]?.clipsToBounds = true
            let waitingToTap = active && !isAnimatingMove
            diceButtons[i]?.setTitle(waitingToTap ? "?" : nil, for: .normal)
            diceButtons[i]?.setTitleColor(.white, for: .normal)
            diceButtons[i]?.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
            diceImages[i]?.alpha = active && waitingToTap ? 0.35 : 1
            diceButtons[i]?.isEnabled = !gameFinished && active && !isAnimatingMove
        }
        updateDiceRollDisplay()
    }
    
    func layoutTokensAtCurrentPositions() {
        guard board_CV.bounds.width > 0, !playerTokens.isEmpty else { return }
        for i in 0..<playerTokens.count {
            let n = playerPositions[i]
            playerTokens[i].center = centerForBoardNumber(n, playerIndex: i)
        }
    }
}

// MARK: - Board Coordinate Helpers

extension GameMainVC {
    
    func cellSize() -> CGSize {
        guard board_CV.bounds.width > 0, board_CV.bounds.height > 0 else { return .zero }
        return CGSize(
            width:  floor(board_CV.bounds.width  / 10),
            height: floor(board_CV.bounds.height / 10)
        )
    }
    
    /// Row from top of collection view (0 = top / tile 100 area), column 0 = left.
    func rowColFromTop(for number: Int) -> (rowTop: Int, col: Int) {
        let rowFromBottom = (number - 1) / 10
        let offsetInRow = (number - 1) % 10
        let col: Int
        if rowFromBottom % 2 == 0 {
            col = offsetInRow
        } else {
            col = 9 - offsetInRow
        }
        let rowTop = 9 - rowFromBottom
        return (rowTop, col)
    }
    
    /// Token center in boardBg_View coordinates (includes small offset when sharing a cell).
    func centerForBoardNumber(_ number: Int, playerIndex: Int) -> CGPoint {
        let (rowTop, col) = rowColFromTop(for: number)
        // FIX: use cellSize() for both x and y so tokens sit correctly on
        // non-square boards (previously both axes used width / 10).
        let size = cellSize()
        let x = CGFloat(col) * (size.width + gridSpacing) + size.width / 2
        let y = CGFloat(rowTop) * (size.height + gridSpacing) + size.height / 2
        let ptInCV = CGPoint(x: x, y: y)
        let offsets: [CGPoint] = [
            CGPoint(x: -7, y: -7),
            CGPoint(x:  7, y: -7),
            CGPoint(x: -7, y:  7),
            CGPoint(x:  7, y:  7)
        ]
        let o = offsets[playerIndex]
        let converted = board_CV.convert(ptInCV, to: boardBg_View)
        return CGPoint(x: converted.x + o.x, y: converted.y + o.y)
    }
    
    func resolveChain(from start: Int) -> Int {
        var pos = start
        for _ in 0..<24 {
            if let tail = snakes[pos] { pos = tail; continue }
            if let top  = ladders[pos] { pos = top;  continue }
            break
        }
        return pos
    }
    
    func chainJumps(from start: Int) -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        var pos = start
        for _ in 0..<24 {
            if let tail = snakes[pos] { result.append((pos, tail)); pos = tail; continue }
            if let top  = ladders[pos] { result.append((pos, top));  pos = top;  continue }
            break
        }
        return result
    }
    
    func numberLinePath(from: Int, to: Int) -> [Int] {
        guard from != to else { return [] }
        let dir = to > from ? 1 : -1
        var path: [Int] = []
        var c = from
        while c != to { c += dir; path.append(c) }
        return path
    }
}

// MARK: - Game Logic

extension GameMainVC {
    
    func handleDiceRoll(for playerIndex: Int, imageView: UIImageView) {
        guard !gameFinished, !isAnimatingMove, currentPlayerIndex == playerIndex else { return }
        isAnimatingMove = true
        lastDiceRoll[playerIndex] = nil
        updateDiceRollDisplay()
        updateActivePlayerUI()
        
        loadGif(into: imageView, name: "dice\(playerIndex + 1).gif")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let diceValue = Int.random(in: 1...6)
            let old = self.playerPositions[playerIndex]
            guard old + diceValue <= 100 else {
                self.isAnimatingMove = false
                self.switchTurn()
                self.updateActivePlayerUI()
                return
            }
            self.lastDiceRoll[playerIndex] = diceValue
            self.updateDiceRollDisplay()
            self.updateActivePlayerUI()
            self.movePlayer(index: playerIndex, steps: diceValue)
        }
    }
    
    func movePlayer(index: Int, steps: Int) {
        let old = playerPositions[index]
        let afterDice = old + steps
        if afterDice > 100 { return }
        
        let walkPath = Array((old + 1)...afterDice)
        let jumps    = chainJumps(from: afterDice)
        let finalPos = resolveChain(from: afterDice)
        
        let finishMove = { [weak self] in
            guard let self = self else { return }
            self.playerPositions[index] = finalPos
            self.layoutTokensAtCurrentPositions()
            self.isAnimatingMove = false
            self.switchTurn()
        }
        
        animateWalk(index: index, path: walkPath) {
            if jumps.isEmpty {
                finishMove()
            } else {
                self.animateJumpSegments(index: index, jumps: jumps) {
                    finishMove()
                }
            }
        }
    }
    
    func animateWalk(index: Int, path: [Int], completion: @escaping () -> Void) {
        guard !path.isEmpty else { completion(); return }
        var stepIndex = 0
        func next() {
            let num   = path[stepIndex]
            let point = self.centerForBoardNumber(num, playerIndex: index)
            UIView.animate(withDuration: 0.11, delay: 0, options: [.curveEaseInOut], animations: {
                self.playerTokens[index].center = point
            }, completion: { _ in
                stepIndex += 1
                if stepIndex < path.count { next() } else { completion() }
            })
        }
        next()
    }
    
    func animateJumpSegments(index: Int, jumps: [(Int, Int)], completion: @escaping () -> Void) {
        guard !jumps.isEmpty else { completion(); return }
        var jumpIdx = 0
        func runNext() {
            let segment = self.numberLinePath(from: jumps[jumpIdx].0, to: jumps[jumpIdx].1)
            self.animateWalk(index: index, path: segment) {
                jumpIdx += 1
                if jumpIdx < jumps.count { runNext() } else { completion() }
            }
        }
        runNext()
    }
    
    func switchTurn() {
        if playerPositions[currentPlayerIndex] == 100 {
            gameFinished = true
            playersTurn_Lbl.text = "Player \(currentPlayerIndex + 1) wins!"
            updateActivePlayerUI()
            return
        }
        currentPlayerIndex = (currentPlayerIndex + 1) % 4
        playersTurn_Lbl.text = "Player \(currentPlayerIndex + 1)'s Turn"
        updateActivePlayerUI()
    }
}

// MARK: - GIF Helper

extension GameMainVC {
    
    func loadGif(into imageView: UIImageView, name: String) {
        do {
            let gif = try UIImage(gifName: name)
            imageView.setGifImage(gif, loopCount: 1)
        } catch {
            print("GIF error: \(error)")
        }
    }
}

// MARK: - CollectionView

extension GameMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        board_CV.delegate   = self
        board_CV.dataSource = self
        board_CV.registerCell(ofType: BoardCVC.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { 100 }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(ofType: BoardCVC.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configure(number: getBoardNumber(index: indexPath.item))
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = floor(collectionView.bounds.width  / 10)
        let height = floor(collectionView.bounds.height / 10)
        return CGSize(width: width, height: height)
    }
    
    /// Collection row 0 is the top of the screen (91–100); row 9 is the bottom (1–10).
    func getBoardNumber(index: Int) -> Int {
        let rowFromTop  = index / 10
        let col         = index % 10
        let rowFromBottom = 9 - rowFromTop
        if rowFromBottom % 2 == 0 {
            return rowFromBottom * 10 + col + 1
        } else {
            return rowFromBottom * 10 + (9 - col) + 1
        }
    }
}

// MARK: - PawnView

class PawnView: UIView {
    private let pawnColor: UIColor
    
    init(color: UIColor) {
        self.pawnColor = color
        super.init(frame: .zero)
        backgroundColor = .clear
        isOpaque = false
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let width       = rect.width
        let height      = rect.height
        let headRadius  = width * 0.28
        let bodyWidth   = width * 0.36
        let bodyHeight  = height * 0.46
        let centerX     = width / 2
        let headCenterY = height * 0.29
        let bodyTopY    = headCenterY + headRadius
        
        // Head
        ctx.setFillColor(pawnColor.cgColor)
        ctx.addEllipse(in: CGRect(x: centerX - headRadius, y: headCenterY - headRadius,
                                  width: headRadius * 2,   height: headRadius * 2))
        ctx.fillPath()
        
        // Body
        let bodyRect = CGRect(x: centerX - bodyWidth / 2, y: bodyTopY,
                              width: bodyWidth, height: bodyHeight)
        let bodyPath = UIBezierPath(roundedRect: bodyRect, cornerRadius: bodyWidth * 0.4)
        ctx.addPath(bodyPath.cgPath)
        ctx.setFillColor(pawnColor.cgColor)
        ctx.fillPath()
        
        // Shadow
        ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 2,
                      color: UIColor.black.withAlphaComponent(0.18).cgColor)
        
        // Specular shine on head
        let shineRadius = headRadius * 0.55
        ctx.setFillColor(UIColor.white.withAlphaComponent(0.20).cgColor)
        ctx.addEllipse(in: CGRect(x: centerX - shineRadius * 0.7,
                                  y: headCenterY - shineRadius * 0.7,
                                  width: shineRadius, height: shineRadius))
        ctx.fillPath()
    }
}
