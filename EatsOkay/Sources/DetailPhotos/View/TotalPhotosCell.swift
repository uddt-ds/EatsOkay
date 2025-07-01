//
//  TotalPhotosCell.swift
//  EatsOkay
//
//  Created by Lee on 6/28/25.
//

import UIKit
import Kingfisher

final class TotalPhotosCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.customColor(hexCode: .primary400).cgColor
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setImageViewHightlight(isHightLighted: Bool) {
        if isHightLighted {
            imageView.layer.borderWidth = 1.5
        } else {
            imageView.layer.borderWidth = 0
        }
    }
    
    func configureImage(uriString: String, isHighlited: Bool) {
        guard let url = URL(string: uriString) else { return }
        imageView.kf.setImage(with: url)
        setImageViewHightlight(isHightLighted: isHighlited)
    }
}
