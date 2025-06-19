//
//  UIView+.swift
//  EatsOkay
//
//  Created by LCH on 6/19/25.
//

import UIKit
import SnapKit

extension UIView {
    
    func showToast(message: String, alpha: CGFloat, constraints: @escaping (_ make: ConstraintMaker) -> Void) {
        
        let imageView = UIImageView(image: .alertCircle)
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedStringManager.configureString(
            text: message,
            font: .customFontForBody(weight: .w400),
            color: .bgColor,
            alignment: .center
        )
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.spacing = 8
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alpha = 0.0
        stack.layer.cornerRadius = 12
        stack.clipsToBounds = true
        stack.backgroundColor = .customColor(hexCode: .neutral950).withAlphaComponent(alpha)
        
        self.addSubview(stack)
        
        stack.snp.makeConstraints { constraints($0) }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            stack.alpha = 1.0
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                stack.alpha = 0.0
            }, completion: { _ in
                stack.removeFromSuperview()
            })
        })
    }
}
