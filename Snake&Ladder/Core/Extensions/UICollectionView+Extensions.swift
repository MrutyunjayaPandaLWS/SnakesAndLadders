//
//  UICollectionView+Extensions.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(ofType cellType: T.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(ofType cellType: T.Type, for indexPath: IndexPath) -> T? {
           let identifier = String(describing: cellType)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
       }
}
