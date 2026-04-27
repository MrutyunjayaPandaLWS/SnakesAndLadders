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
    
    private let gridSpacing: CGFloat = 2
    private var isAnimatingMove = false
    
    let snakes: [Int: Int] = [
        98: 2,
        85: 49,
        61: 40,
        54: 37,
        32: 7
    ]
    
    let ladders: [Int: Int] = [
        3: 24,
        14: 77,
        30: 51,
        41: 62,
        53: 72,
        88: 93
    ]
    
    private var didInitialLayout = false
    
    var gameMode: GameMode = .fourPlayer
    
    // MARK: - Derived from gameMode
    
    /// Number of active players for the current mode.
    private var activePlayerCount: Int {
        switch gameMode {
        case .twoPlayer:   return 2
        case .threePlayer: return 3
        case .fourPlayer:  return 4
        case .versusAI:    return 2
        }
    }
    
    /// Whether the current player is controlled by the AI.
    private var isCurrentPlayerAI: Bool {
        guard gameMode == .versusAI else { return false }
        return currentPlayerIndex == 1   // player 2 (index 1) is AI
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playersTurn_Lbl.textColor = .white
        playersTurn_Lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        
        board_CV.backgroundColor = .clear
        board_CV.isScrollEnabled = false
        if let layout = board_CV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = gridSpacing
            layout.minimumLineSpacing = gridSpacing
            layout.sectionInset = .zero
        }
        setupGameMode()
        setupCollectionView()
        setupSnakeLadderOverlay()
        setupPlayerAvatars()
        setupTokens()
        updateActivePlayerUI()
        triggerAITurnIfNeeded()
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
    
    func setupGameMode() {
        switch gameMode {
        case .twoPlayer:
            p1Main_View.isHidden = false
            p2Main_View.isHidden = false
            p3Main_View.isHidden = true
            p4Main_View.isHidden = true
        case .threePlayer:
            p1Main_View.isHidden = false
            p2Main_View.isHidden = false
            p3Main_View.isHidden = false
            p4Main_View.isHidden = true
        case .fourPlayer:
            p1Main_View.isHidden = false
            p2Main_View.isHidden = false
            p3Main_View.isHidden = false
            p4Main_View.isHidden = false
        case .versusAI:
            p1Main_View.isHidden = false
            p2Main_View.isHidden = false
            p3Main_View.isHidden = true
            p4Main_View.isHidden = true
        }
    }
    
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
        // In versusAI mode, label the second player as "AI"
        if gameMode == .versusAI {
            p2Title_Lbl.text = "AI"
        }
    }
    
//    func setupTokens() {
//        let colors: [UIColor] = [
//            UIColor(red: 0.92, green: 0.22, blue: 0.22, alpha: 1),
//            UIColor(red: 0.18, green: 0.45, blue: 0.92, alpha: 1),
//            UIColor(red: 0.98, green: 0.82, blue: 0.22, alpha: 1),
//            UIColor(red: 0.18, green: 0.78, blue: 0.34, alpha: 1)
//        ]
//        // Only create tokens for active players
//        for i in 0..<activePlayerCount {
//            let pawn = PawnView(color: colors[i])
//            pawn.bounds = CGRect(x: 0, y: 0, width: 22, height: 28)
//            boardBg_View.addSubview(pawn)
//            playerTokens.append(pawn)
//        }
//        boardBg_View.bringSubviewToFront(snakeLadderOverlay)
//        playerTokens.forEach { boardBg_View.bringSubviewToFront($0) }
//    }
    
    func setupTokens() {
        playerTokens.removeAll()

        for i in 0..<activePlayerCount {
            let imageName = "token_p\(i + 1)"   // 👈 IMPORTANT naming

            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit

            imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

            boardBg_View.addSubview(imageView)
            playerTokens.append(imageView)
        }

        boardBg_View.bringSubviewToFront(snakeLadderOverlay)
        playerTokens.forEach { boardBg_View.bringSubviewToFront($0) }
    }
}

// MARK: - UI Updates

extension GameMainVC {
    
    func updateActivePlayerUI() {
        let mains       = [p1Main_View, p2Main_View, p3Main_View, p4Main_View]
        let diceButtons = [p1Dice_Btn, p2Dice_Btn, p3Dice_Btn, p4Dice_Btn]
        let diceImages  = [p1Dice_ImgView, p2Dice_ImgView, p3Dice_ImgView, p4Dice_ImgView]

        for i in 0..<4 {
            let active = i == currentPlayerIndex && !gameFinished
            mains[i]?.layer.borderWidth = active ? 3 : 0
            mains[i]?.layer.borderColor = UIColor(red: 1, green: 0.85, blue: 0.2, alpha: 1).cgColor
            mains[i]?.layer.cornerRadius = 8
            mains[i]?.clipsToBounds = true

            // AI turn: show no "?" prompt on the AI's dice button
            let isAISlot = (gameMode == .versusAI && i == 1)
            let waitingToTap = active && !isAnimatingMove && !isAISlot
            diceButtons[i]?.setTitle(waitingToTap ? "?" : nil, for: .normal)
            diceButtons[i]?.setTitleColor(.white, for: .normal)
            diceButtons[i]?.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
            diceImages[i]?.isHidden = !active
            diceImages[i]?.alpha = waitingToTap ? 0.35 : 1.0

            // Human can only tap their own button when it is their turn
            let isHumanTurn = active && !isAnimatingMove && !isAISlot
            diceButtons[i]?.isEnabled = !gameFinished && isHumanTurn
        }
        updateTurnLabel()
    }

    /// Keeps the turn label accurate for all modes, including VS AI.
    private func updateTurnLabel() {
        if gameFinished { return }
        if gameMode == .versusAI {
            playersTurn_Lbl.text = currentPlayerIndex == 0 ? "Your Turn" : "AI's Turn"
        } else {
            playersTurn_Lbl.text = "Player \(currentPlayerIndex + 1)'s Turn"
        }
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
        let width = (board_CV.bounds.width - gridSpacing * 9) / 10
        let height = (board_CV.bounds.height - gridSpacing * 9) / 10
        return CGSize(
            width: floor(width),
            height: floor(height)
        )
    }
    
    func rowColFromTop(for number: Int) -> (rowTop: Int, col: Int) {
        let rowFromBottom = (number - 1) / 10
        let offsetInRow   = (number - 1) % 10
        let col: Int
        if rowFromBottom % 2 == 0 {
            col = offsetInRow
        } else {
            col = 9 - offsetInRow
        }
        let rowTop = 9 - rowFromBottom
        return (rowTop, col)
    }
    
    func centerForBoardNumber(_ number: Int, playerIndex: Int) -> CGPoint {
        let (rowTop, col) = rowColFromTop(for: number)
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
        updateActivePlayerUI()

        let diceValue = Int.random(in: 1...6)
//        let diceValue = 2
        loadGif(into: imageView, name: "dice\(diceValue).gif")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let old = self.playerPositions[playerIndex]
            let isBonusSpin = (diceValue == 1 || diceValue == 6)

            guard old + diceValue <= 100 else {
                self.isAnimatingMove = false
                if isBonusSpin {
                    self.showBonusSpinBanner(for: playerIndex)
                } else {
                    self.switchTurn()
                }
                self.updateActivePlayerUI()
                return
            }

            self.updateActivePlayerUI()
            self.movePlayer(index: playerIndex, steps: diceValue, bonusSpin: isBonusSpin)
        }
    }

    func switchTurn(bonusSpin: Bool = false) {
        if playerPositions[currentPlayerIndex] == 100 {
            gameFinished = true
            if gameMode == .versusAI {
                playersTurn_Lbl.text = currentPlayerIndex == 0 ? "You Win! 🎉" : "AI Wins!"
            } else {
                playersTurn_Lbl.text = "Player \(currentPlayerIndex + 1) Wins! 🎉"
            }
            updateActivePlayerUI()
            return
        }

        if bonusSpin {
            // Same player gets another turn — just refresh UI and re-trigger AI if needed.
            showBonusSpinBanner(for: currentPlayerIndex)
            return
        }

        // Cycle only through active players
        currentPlayerIndex = (currentPlayerIndex + 1) % activePlayerCount
        updateActivePlayerUI()
        // If it's now the AI's turn, trigger it automatically
        triggerAITurnIfNeeded()
    }

    /// Shows a brief "Bonus Spin!" banner then re-enables the current player's turn.
    private func showBonusSpinBanner(for playerIndex: Int) {
        let name: String
        if gameMode == .versusAI {
            name = playerIndex == 0 ? "You get" : "AI gets"
        } else {
            name = "Player \(playerIndex + 1) gets"
        }
        playersTurn_Lbl.text = "\(name) a Bonus Spin! 🎲"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self, !self.gameFinished else { return }
            self.updateActivePlayerUI()          // restores normal turn label + enables button
            self.triggerAITurnIfNeeded()         // auto-rolls for AI if it's the AI's bonus spin
        }
    }
    
    /// Fires an AI dice roll automatically after a short pause, if it is the AI's turn.
    func triggerAITurnIfNeeded() {
        guard !gameFinished, isCurrentPlayerAI else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self, !self.gameFinished, self.isCurrentPlayerAI, !self.isAnimatingMove else { return }
            self.handleDiceRoll(for: self.currentPlayerIndex, imageView: self.p2Dice_ImgView)
        }
    }
}

// MARK: - Move Animations

extension GameMainVC {
    
    func animateWalk(index: Int, path: [Int], stepDuration: Double = 0.20, completion: @escaping () -> Void) {
        guard !path.isEmpty else { completion(); return }
        var stepIndex = 0
        func next() {
            let num   = path[stepIndex]
            let point = self.centerForBoardNumber(num, playerIndex: index)

            UIView.animate(withDuration: stepDuration,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                self.playerTokens[index].center = point
            }, completion: { _ in
                stepIndex += 1
                if stepIndex < path.count { next() } else { completion() }
            })
        }
        next()
    }
    
    func movePlayer(index: Int, steps: Int, bonusSpin: Bool = false) {
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
            self.switchTurn(bonusSpin: bonusSpin)
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
    
    func animateJumpSegments(index: Int, jumps: [(Int, Int)], completion: @escaping () -> Void) {
        guard !jumps.isEmpty else {
            completion()
            return
        }

        var jumpIdx = 0

        func runNext() {
            let (from, to) = jumps[jumpIdx]
            let isLadder = ladders[from] == to

            let fromPt = centerForBoardNumber(from, playerIndex: index)
            let toPt   = centerForBoardNumber(to,   playerIndex: index)

            // ✅ Distance-based animation
            let distance = hypot(toPt.x - fromPt.x, toPt.y - fromPt.y)

            // 🎯 Tune speeds here
            let speed: CGFloat = isLadder ? 180 : 260   // ladder slower, snake faster

            let duration = TimeInterval(distance / speed)

            animateSlidePath(
                index: index,
                from: fromPt,
                to: toPt,
                duration: duration,
                isLadder: isLadder
            ) {
                jumpIdx += 1
                if jumpIdx < jumps.count {
                    runNext()
                } else {
                    completion()
                }
            }
        }

        runNext()
    }
    
    func animateSlidePath(
        index: Int,
        from: CGPoint,
        to: CGPoint,
        duration: TimeInterval,
        isLadder: Bool,
        completion: @escaping () -> Void
    ) {
        playerTokens[index].center = from

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: isLadder ? [.curveEaseOut] : [.curveEaseIn],
            animations: {
                self.playerTokens[index].center = to
            },
            completion: { _ in
                completion()
            }
        )
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
        let number = getBoardNumber(index: indexPath.item)
        let rowFromTop = indexPath.item / 10
        let col = indexPath.item % 10
        let isAlternate = (rowFromTop + col).isMultiple(of: 2)
        cell.configure(number: number, isAlternate: isAlternate)
        cell.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = floor((collectionView.bounds.width  - gridSpacing * 9) / 10)
        let height = floor((collectionView.bounds.height - gridSpacing * 9) / 10)
        return CGSize(width: width, height: height)
    }
    
    func getBoardNumber(index: Int) -> Int {
        let rowFromTop    = index / 10
        let col           = index % 10
        let rowFromBottom = 9 - rowFromTop
        if rowFromBottom % 2 == 0 {
            return rowFromBottom * 10 + col + 1
        } else {
            return rowFromBottom * 10 + (9 - col) + 1
        }
    }
}
