//
//  CustomHeaderView.swift
//  EatsOkay
//
//  Created by 허성필 on 6/30/25.
//

import UIKit
import SnapKit

final class CustomHeaderView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.attributedText = AttributedStringManager
            .configureString(text: text,
                             font: .customFontForHeader(weight: .w800),
                             color: .neutral950)
    }
}
