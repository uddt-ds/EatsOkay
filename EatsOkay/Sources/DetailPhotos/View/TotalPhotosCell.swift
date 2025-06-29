//
//  TotalPhotosCell.swift
//  EatsOkay
//
//  Created by Lee on 6/28/25.
//

import UIKit

class TotalPhotosCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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

    func configureImage(imageName: String) {
        imageView.image = UIImage(named: imageName)
    }

}
