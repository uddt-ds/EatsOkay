//
//  AttributedStringManager.swift
//  EatsOkay
//
//  Created by LCH on 6/17/25.
//

import UIKit

struct AttributedStringManager {
    
    static func configureString(
        text: String, font: UIFont, color: UIColor.CustomColor, alignment: NSTextAlignment = .left
    ) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attributedString.length)
        
        let customColor = UIColor.customColor(hexCode: color)

        let lineHeightRatio: CGFloat = 1.41
        let targetLineHeight = font.pointSize * lineHeightRatio
        let lineHeightMultiple = targetLineHeight / font.lineHeight
        let baselineOffset = (targetLineHeight - font.lineHeight) / 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.minimumLineHeight = targetLineHeight
        paragraphStyle.maximumLineHeight = targetLineHeight
        
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: customColor, range: range)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: range)
        
        return attributedString
    }
    
    static func configureString(
        text: String, font: UIFont, color: UIColor.CustomColor, alignment: NSTextAlignment = .left
    ) -> AttributedString {
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attributedString.length)
        
        let customColor = UIColor.customColor(hexCode: color)

        let lineHeightRatio: CGFloat = 1.41
        let targetLineHeight = font.pointSize * lineHeightRatio
        let lineHeightMultiple = targetLineHeight / font.lineHeight
        let baselineOffset = (targetLineHeight - font.lineHeight) / 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.minimumLineHeight = targetLineHeight
        paragraphStyle.maximumLineHeight = targetLineHeight
        
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: customColor, range: range)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: range)
        
        return AttributedString(attributedString)
    }
}
