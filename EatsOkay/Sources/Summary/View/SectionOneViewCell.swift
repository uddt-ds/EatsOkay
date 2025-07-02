//
//  SectionOneViewCell.swift
//  EatsOkay
//
//  Created by 허성필 on 6/30/25.
//

import UIKit
import SnapKit
import Kingfisher

class SectionOneViewCell: UICollectionViewCell {
    static let identifier = "SectionOneViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let photoPageLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "1 / 3",
            font: UIFont.customFontForBody(weight: .w500),
            color: .bgColor
        )
        label.backgroundColor = UIColor.customColor(hexCode: .neutral950).withAlphaComponent(0.6)
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private let testView = UIView()
    private let contentViews: [UIImageView] = {
        ["DefaultImage", "DefaultImage", "DefaultImage"].map { imageName in
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
    }()
    
    private func configureUI() {
        contentView.backgroundColor = .white
        
        scrollView.addSubview(testView)
        scrollView.addSubview(backgroundImageView)
        contentViews.forEach { testView.addSubview($0) }
        
        [
            scrollView, photoPageLabel
        ]
            .forEach { contentView.addSubview($0) }
        
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        testView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(contentViews.count)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height)
        }
        
        for (index, view) in contentViews.enumerated() {
            view.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(scrollView.snp.width)
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(contentViews[index - 1].snp.trailing)
                }
            }
        }
        
        photoPageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.width.equalTo(45)
            make.height.equalTo(26)
        }
        
    }
    
    func update(with: SummarySectionModel.CellModel) {
        switch with {
        case .summaryImageCell(let data):
            for (index, urlString) in data.photosUrl.enumerated() {
                if index < contentViews.count {
                    if urlString == "DefaultImage" {
                        contentViews[index].image = UIImage(named: "DefaultImage")
                    } else if let url = URL(string: urlString), urlString.hasPrefix("https") {
                        contentViews[index].kf.setImage(with: url)
                    } else {
                        contentViews[index].image = UIImage(named: "DefaultImage")
                    }
                }
            }
        default:
            break
        }
    }
}
