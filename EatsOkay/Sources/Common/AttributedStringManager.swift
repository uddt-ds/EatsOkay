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
        paragraphStyle.alignment = alignment
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
        paragraphStyle.alignment = alignment
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.minimumLineHeight = targetLineHeight
        paragraphStyle.maximumLineHeight = targetLineHeight
        
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: customColor, range: range)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: range)
        
        return AttributedString(attributedString)
    }
    
    static func configureHighlightString(
        text: String,
        font: UIFont,
        color: UIColor.CustomColor,
        alignment: NSTextAlignment = .left,
        highlightWords: [HighlightWord] = []
    ) -> NSMutableAttributedString {
        
        let attributedString: NSMutableAttributedString = configureString(
            text: text,
            font: font,
            color: color,
            alignment: alignment
        )
        
        let nsText = text as NSString
        for highlightWord in highlightWords {
            var searchRange = NSRange(location: 0, length: nsText.length)
            
            while true {
                let foundRange = nsText.range(of: highlightWord.word, options: [], range: searchRange)
                if foundRange.location == NSNotFound { break }
                
                attributedString.addAttribute(
                    .foregroundColor,
                    value: UIColor.customColor(hexCode: highlightWord.color),
                    range: foundRange
                )
                
                let nextLocation = foundRange.location + foundRange.length
                searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
            }
        }
        
        return attributedString
    }
}

extension AttributedStringManager {
    struct HighlightWord {
        let word: String
        let color: UIColor.CustomColor
    }
}
