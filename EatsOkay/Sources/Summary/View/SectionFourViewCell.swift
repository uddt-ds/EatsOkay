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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .company1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let markerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .blackMarker)
        return imageView
    }()
    
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "주소"
        
        label.numberOfLines = 0
        
        return label
    }()
    
    private func configureView() {
        [imageView, stackView].forEach {
            self.addSubview($0)
        }
        
        [markerImageView, addressLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        // 가로 사이즈 375 / 세로사이즈 815
        // 335 / 172
        // 0.8933 / 0.211
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(imageView.snp.width).multipliedBy(172.0 / 335.0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.width.equalTo(imageView.snp.width)
            $0.centerX.equalToSuperview()
        }
        
        markerImageView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.centerY.equalTo(addressLabel.snp.centerY)
        }
        
        addressLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            
        }
    }
    
    func update(image: UIImage?) {
        imageView.image = image
    }
    
    func update(text: String) {
        addressLabel.text = text
    }
}
