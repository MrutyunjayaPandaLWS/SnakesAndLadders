//
//  GameVC.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit


final class GameVC: UIViewController {
    
    // MARK: - UI
    private var collectionView: UICollectionView!
    private let diceView = DiceView()
    
    // MARK: - ViewModel
    private let viewModel: GameViewModel
    
    // MARK: - Init
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


private extension GameVC {
    
    func setupUI() {
        view.backgroundColor = .white
        
        setupCollectionView()
        setupDiceView()
    }
    
    // MARK: - CollectionView
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(BoardCell.self, forCellWithReuseIdentifier: BoardCell.identifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor) // Square grid
        ])
    }
    
    // MARK: - Dice
    
    func setupDiceView() {
        diceView.translatesAutoresizingMaskIntoConstraints = false
        diceView.setTitle("🎲 Roll", for: .normal)
        diceView.backgroundColor = .systemPurple
        diceView.layer.cornerRadius = 10
        
        diceView.addTarget(self, action: #selector(didTapDice), for: .touchUpInside)
        
        view.addSubview(diceView)
        
        NSLayoutConstraint.activate([
            diceView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            diceView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            diceView.widthAnchor.constraint(equalToConstant: 120),
            diceView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func didTapDice() {
        diceView.roll { [weak self] value in
            guard let self = self else { return }
            
            let result = self.viewModel.moveCurrentPlayer(steps: value)
            
            print("Move from \(result.from) to \(result.to)")
            
            // TODO: Animate movement here
        }
    }
    
    
    func getBoardNumber(index: Int) -> Int {
        let row = index / 10
        let col = index % 10
        
        if row % 2 == 0 {
            return row * 10 + col + 1
        } else {
            return row * 10 + (9 - col) + 1
        }
    }
}

extension GameVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BoardCell.identifier,
            for: indexPath
        ) as! BoardCell
        
        let number = getBoardNumber(index: indexPath.item)
        cell.configure(number: number)
        
        return cell
    }
}


extension GameVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing: CGFloat = 18 // adjust based on spacing
        let width = (collectionView.frame.width - totalSpacing) / 10
        
        return CGSize(width: width, height: width)
    }
}
