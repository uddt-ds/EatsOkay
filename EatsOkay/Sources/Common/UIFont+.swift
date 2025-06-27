//
//  UIFont+.swift
//  EatsOkay
//
//  Created by LCH on 6/9/25.
//

import UIKit

enum CustomFontWeight: CGFloat {
    case w950 = 24
    case w900 = 20
    case w800 = 18
    case w700 = 16
    case w600 = 14
    case w500 = 13
    case w400 = 12
}

extension UIFont {
    static func customFontForHeader(weight: CustomFontWeight) -> UIFont {
        if let font = UIFont(name: "Pretendard-Bold", size: weight.rawValue) {
            return font
        } else {
            return UIFont.systemFont(ofSize: weight.rawValue)
        }
    }
    
    static func customFontForSubtitle(weight: CustomFontWeight) -> UIFont {
        if let font = UIFont(name: "Pretendard-Medium", size: weight.rawValue) {
            return font
        } else {
            return UIFont.systemFont(ofSize: weight.rawValue)
        }
    }
    
    static func customFontForBody(weight: CustomFontWeight) -> UIFont {
        if let font = UIFont(name: "Pretendard-Regular", size: weight.rawValue) {
            return font
        } else {
            return UIFont.systemFont(ofSize: weight.rawValue)
        }
    }
    
    static func customFontForButton(weight: CustomFontWeight) -> UIFont {
        if let font = UIFont(name: "Pretendard-Medium", size: weight.rawValue) {
            return font
        } else {
            return UIFont.systemFont(ofSize: weight.rawValue)
        }
    }
}
