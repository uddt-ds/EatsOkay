//
//  CustomButton.swift
//  EatsOkay
//
//  Created by LCH on 6/11/25.
//

import UIKit

class CustomButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ?
                .customColor(hexCode: .primary600) : .customColor(hexCode: .primary400)
        }
    }
    
    private func configure() {
        self.setTitleColor(.customColor(hexCode: .bgColor), for: .normal)
        self.backgroundColor = .customColor(hexCode: .primary400)
        self.titleLabel?.font = .customFontForHeader(weight: .w900)
        self.layer.cornerRadius = 8
    }
}
