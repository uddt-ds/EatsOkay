//
//  SectionFourViewCell.swift
//  EatsOkay
//
//  Created by 허성필 on 6/30/25.
//

import UIKit
import SnapKit
import Kingfisher

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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.customColor(hexCode: .neutral100).cgColor
        imageView.kf.indicatorType = .activity
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
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
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
    
    func update(with: SummarySectionModel.CellModel ) {
        switch with {
        case .summaryMapCell(let summaryMapResult):
            addressLabel.text = summaryMapResult.address
            if let url = URL(string: summaryMapResult.imageUrl) {
                imageView.kf.setImage(with: url,
                                      options: [
                                        .onFailureImage(UIImage(resource: .default))
                                      ]
                )
            }
        default:
            break
            
        }
    }
}
