//
//  SectionTwoViewCell.swift
//  EatsOkay
//
//  Created by 허성필 on 6/30/25.
//

import UIKit
import SnapKit

class SectionTwoViewCell: UICollectionViewCell {
    static let identifier = "SectionTwoViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "서울 강남구 • 일식당 ",
            font: UIFont.customFontForBody(weight: .w500),
            color: .neutral400
        )
        return label
    }()
    
    private let storeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "식당이름입니다 ",
            font: UIFont.customFontForHeader(weight: .w950),
            color: .neutral950
        )
        return label
    }()
    
    private let rateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Star")
        return imageView
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "4.8",
            font: UIFont.customFontForHeader(weight: .w700),
            color: .neutral950
        )
        return label
    }()
    
    private let dotLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "•",
            font: UIFont.customFontForBody(weight: .w500),
            color: .neutral950
        )
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "리뷰 40개",
            font: UIFont.customFontForSubtitle(weight: .w700),
            color: .neutral950
        )
        return label
    }()
    
    private let separator = CustomSeparator(color: .neutral50)
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Time")
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedStringManager.configureString(
            text: "영업 종료 • 18:00에 영업 시작",
            font: UIFont.customFontForBody(weight: .w600),
            color: .neutral800
        )
        return label
    }()
    
    private let callButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "Call")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4
        configuration.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        configuration.attributedTitle = AttributedStringManager.configureString(
                text: "전화",
                font: .customFontForBody(weight: .w600),
                color: .neutral700
        )
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = UIColor.customColor(hexCode: .neutral100)
        configuration.background.cornerRadius = 50
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private let secondSeparator = CustomSeparator(color: .neutral50)
    
    private func configureView() {
        [regionLabel, storeLabel, rateImageView, rateLabel, dotLabel, reviewLabel,
         separator ,timeImageView, timeLabel, callButton, secondSeparator].forEach {
            addSubview($0)
        }
        
        regionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        storeLabel.snp.makeConstraints { make in
            make.top.equalTo(regionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        rateImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(rateLabel)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(storeLabel.snp.bottom).offset(10)
            make.leading.equalTo(rateImageView.snp.trailing).offset(4)
        }
        
        dotLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rateLabel)
            make.leading.equalTo(rateLabel.snp.trailing).offset(4)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(storeLabel.snp.bottom).offset(10)
            make.leading.equalTo(dotLabel.snp.trailing).offset(4)
        }
        
        separator.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(reviewLabel.snp.bottom).offset(20)
            make.height.equalTo(2)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.leading.equalToSuperview().offset(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(separator).offset(20)
            make.leading.equalTo(timeImageView.snp.trailing).offset(4)
        }
        
        secondSeparator.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
        }
        
        callButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    func update(storeInfo: StoreInfo) {
        regionLabel.text = "\(formatAddress(storeInfo.formattedAddress)) • \(storeInfo.primaryTypeDisplayName)"
        storeLabel.text = storeInfo.displayName
        rateLabel.text = "\(storeInfo.rating)"
        reviewLabel.text = "리뷰 \(storeInfo.userRatingCount)개"
        
        let openInfo = storeInfo.currentOpeningHours
        let openInfoText = OpeningHours.getTodayClosingOrTomorrowOpening(openingHours: openInfo)
        
        timeLabel.text = storeInfo.currentOpeningHours.openNow ? "영업중" + " • \(openInfoText)" : "영업 종료" + " • \(openInfoText)"
    }
}

extension SectionTwoViewCell {
    // ex) 서울특별시 OO구 OO동 OOOOO을 서울시 OO구로 변환하는 함수
    func formatAddress(_ fullAddress: String) -> String {
        // 공백을 기준으로 분리
        let components = fullAddress.components(separatedBy: " ")
        
        // 최소 3개 이상이어야 시, 구 추출 가능
        guard components.count >= 3 else { return fullAddress }
        
        // 두 번째(시/도), 세 번째(구/군)만 추출
        // "서울특별시" → "서울"로 변환
        let city = components[1]
            .replacingOccurrences(of: "특별시", with: "")
            .replacingOccurrences(of: "특별자치도", with: "")
            .replacingOccurrences(of: "특별자치시", with: "")
            .replacingOccurrences(of: "광역시", with: "")
            .replacingOccurrences(of: "시", with: "")
            .replacingOccurrences(of: "도", with: "")
        
        // "OO구"는 그대로 사용
        let district = components[2]
        
        return "\(city) \(district)"
    }
}
