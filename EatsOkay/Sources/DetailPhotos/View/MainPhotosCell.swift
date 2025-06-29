//
//  MainPhotoCell.swift
//  EatsOkay
//
//  Created by Lee on 6/28/25.
//

import UIKit
import SnapKit

class MainPhotosCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "company1"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private func configureUI() {
        self.addSubview(imageView)
    }

    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // 여기서 데이터 가져와서 처리해야함
    private func setImage(string: String) {
        imageView.image = UIImage(named: string)
    }
}
