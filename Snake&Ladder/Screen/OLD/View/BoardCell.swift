//
//  BoardCell.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit


final class BoardCell: UICollectionViewCell {
    
    static let identifier = "BoardCell"
    
    private let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemYellow
        contentView.layer.cornerRadius = 6
        
        numberLabel.font = .systemFont(ofSize: 10)
        contentView.addSubview(numberLabel)
        numberLabel.frame = CGRect(x: 4, y: 4, width: 40, height: 20)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(number: Int) {
        numberLabel.text = "\(number)"
    }
}
