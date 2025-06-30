//
//  SectionFourViewCell.swift
//  EatsOkay
//
//  Created by 허성필 on 6/30/25.
//

import UIKit
import SnapKit

class SectionFourViewCell: UICollectionViewCell {
    static let identifier = "SectionFourViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .black
        return label
    }()
    
    private func configureView() {
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func update(text: String) {
        label.text = text
    }
}
