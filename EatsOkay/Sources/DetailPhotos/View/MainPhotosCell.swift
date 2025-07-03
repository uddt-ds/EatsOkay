//
//  MainPhotoCell.swift
//  EatsOkay
//
//  Created by Lee on 6/28/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MainPhotosCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    
    func configureImage(uriString: String) {
        guard let url = URL(string: uriString) else { return }
        imageView.kf.setImage(with: url)
    }
}
