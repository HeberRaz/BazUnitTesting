//
//  ShadowStyler.swift
//  UnitTestingBaz
//
//  Created by Heber Raziel Alvarez Ruedas on 04/11/22.
//

import UIKit

struct ShadowStyler {
    
    // MARK: - Properties
    private typealias Constants = PokedexMainConstants
    
    // MARK: - Methods
    
    static func apply(to view: UIView) {
        view.layer.cornerRadius = Constants.commonCornerRadius
        view.backgroundColor = view.backgroundColor ?? .white
        // Border
        view.layer.borderWidth = Constants.commonCellBorderWidth
        view.layer.borderColor = UIColor.white.cgColor

        // Shadow
        view.layer.shadowColor = Constants.commonCellShadowColor
        view.layer.shadowOffset = Constants.commonCellShadowOffset
        view.layer.shadowOpacity = Constants.commonCellShadowOpacity
        view.layer.shadowRadius = Constants.commonCellShadowRadius
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    static func remove(from view: UIView) {
        view.layer.cornerRadius = 0 //Constants.commonCornerRadius
        view.backgroundColor = view.backgroundColor ?? .white
        // Border
        view.layer.borderWidth = 0 //Constants.commonCellBorderWidth
        view.layer.borderColor = .none // UIColor.white.cgColor

        // Shadow
        view.layer.shadowColor = .none // Constants.commonCellShadowColor
        view.layer.shadowOffset = .zero // Constants.commonCellShadowOffset
        view.layer.shadowOpacity = 0 // Constants.commonCellShadowOpacity
        view.layer.shadowRadius = 0 // Constants.commonCellShadowRadius
        view.layer.shouldRasterize = false
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
