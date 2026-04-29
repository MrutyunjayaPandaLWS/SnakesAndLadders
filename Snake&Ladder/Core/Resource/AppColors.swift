//
//  Colors.swift
//  Snake&Ladder
//
//  Created by LoyltWorks on 31/03/26.
//

import UIKit

struct AppColor {
    static let primary = UIColor.load(.primary)
    static let secondary = UIColor.load(.secondary)
    static let teriary = UIColor.load(.teriary)
}


enum colorName: String{
    case primary = "Primary"
    case secondary = "Secondary"
    case teriary = "Tertiary"
}

extension UIColor {

    /// Safely loads a color from asset catalog with fallback
    static func load(_ color: colorName, fallback: UIColor = .systemOrange) -> UIColor {
        return UIColor(named: color.rawValue) ?? fallback
    }
}
