//
//  CustomSeparator.swift
//  EatsOkay
//
//  Created by 허성필 on 6/24/25.
//

import UIKit

final class CustomSeparator: UIView {
    init(color: UIColor.CustomColor = .neutral50) {
        super.init(frame: .zero)
        backgroundColor = UIColor.customColor(hexCode: color)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}
