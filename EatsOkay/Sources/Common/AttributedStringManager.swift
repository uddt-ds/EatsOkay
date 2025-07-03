//
//  AttributedStringManager.swift
//  EatsOkay
//
//  Created by LCH on 6/17/25.
//

import UIKit

/// 디자인 시스템과 일치된 AttributedString 적용을 위한 구조체
struct AttributedStringManager {
    
    /// AttributedString에 LineHeight 140% 적용을 위한 메서드
    /// - Parameters:
    ///   - text: AttributedString을 적용할 텍스트 입력
    ///   - font: AttributedString에 적용할 폰트 입력
    ///   - color: AttributedString에 적용할 색상 입력(색상은 CustomColor만 가능)
    ///   - alignment: (기본값 left) AttributedString에 적용할 정렬 기준 입력
    ///   - lineBreak: (기본값 nil) AttributedString에 적용할 lineBreakMode 입력
    ///   - breakStrategy: (기본값 nil) AttributedString에 적용할 lineBreakStrategy 입력
    /// - Returns: NSMutableAttributedString을 반환
    ///
    /// ```swift
    /// let label = UILabel()
    ///
    /// label.attributedText = AttributedStringManager.configureString(
    ///     text: "안녕하세요.",
    ///     font: .customFontForHeader(weight: .w950),
    ///     color: .neutral950
    /// )
    /// ```
    ///
    static func configureString(
        text: String, font: UIFont, color: UIColor.CustomColor, alignment: NSTextAlignment = .left, lineBreak: NSLineBreakMode? = nil, breakStrategy: NSParagraphStyle.LineBreakStrategy? = nil
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
        
        if let lineBreak {
            paragraphStyle.lineBreakMode = lineBreak
        }
        
        if let breakStrategy {
            paragraphStyle.lineBreakStrategy = breakStrategy
        }
        
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: customColor, range: range)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: range)
        
        return attributedString
    }
    
    /// AttributedString에 LineHeight 140% 적용을 위한 메서드
    /// - Parameters:
    ///   - text: AttributedString을 적용할 텍스트 입력
    ///   - font: AttributedString에 적용할 폰트 입력
    ///   - color: AttributedString에 적용할 색상 입력(색상은 CustomColor만 가능)
    ///   - alignment: (기본값 left) AttributedString에 적용할 정렬 기준 입력
    ///   - lineBreak: (기본값 nil) AttributedString에 적용할 lineBreakMode 입력
    ///   - breakStrategy: (기본값 nil) AttributedString에 적용할 lineBreakStrategy 입력
    /// - Returns: AttributedString을 반환
    ///
    /// ```swift
    /// var configuration = UIButton.Configuration.plain()
    /// configuration.attributedTitle = AttributedStringManager.configureString(
    ///     text: "설정",
    ///     font: .customFontForSubtitle(weight: .w700),
    ///     color: .infoColor,
    ///     alignment: .center
    /// )
    ///
    /// let button = UIButton(configuration: configuration)
    /// ```
    ///
    static func configureString(
        text: String, font: UIFont, color: UIColor.CustomColor, alignment: NSTextAlignment = .left, lineBreak: NSLineBreakMode? = nil, breakStrategy: NSParagraphStyle.LineBreakStrategy? = nil
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
        
        if let lineBreak {
            paragraphStyle.lineBreakMode = lineBreak
        }
        
        if let breakStrategy {
            paragraphStyle.lineBreakStrategy = breakStrategy
        }
        
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: customColor, range: range)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attributedString.addAttribute(.baselineOffset, value: baselineOffset, range: range)
        
        return AttributedString(attributedString)
    }
    
    /// AttributedString에 LineHeight 140%와 부분 Highlight 적용을 위한 메서드
    /// - Parameters:
    ///   - text: AttributedString을 적용할 텍스트 입력
    ///   - font: AttributedString에 적용할 폰트 입력
    ///   - color: AttributedString에 적용할 색상 입력(색상은 CustomColor만 가능)
    ///   - alignment: (기본값 left) AttributedString에 적용할 정렬 기준 입력
    ///   - highlightWords: AttributedString에 부분적으로 Highlight를 적용할 텍스트와 색상 입력
    /// - Returns: NSMutableAttributedString을 반환
    ///
    /// ```swift
    /// let label = UILabel()
    ///
    /// label.attributedText = AttributedStringManager.configureHighlightString(
    ///     text: "Hello, Swift",
    ///     font: .customFontForBody(weight: .w500),
    ///     color: .neutral700,
    ///     highlightWords: [
    ///         .init(word: "Hello", color: .primary400)
    ///     ]
    /// )
    /// ```
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
