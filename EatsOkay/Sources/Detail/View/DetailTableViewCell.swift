//
//  DetailTableViewCell.swift
//  EatsOkay
//
//  Created by 허성필 on 6/9/25.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

class DetailTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    var disposeBag = DisposeBag()
    
    private let storeNameLabel = UILabel()
    
    private let rateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Star")
        return imageView
    }()
    
    private let rateLabel = UILabel()
    
    private let userRateCountLabel = UILabel()
    
    private let storeTypeLabel = UILabel()
    
    private let addressLabel = UILabel()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Time")
        return imageView
    }()
    
    private let openNowLabel = UILabel()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle")
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let separatorView = CustomSeparator(color: .neutral50)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 셀 재사용 시 상태 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - UI setUP 부분 -
    func setupViews() {
        
        contentView.backgroundColor = .customColor(hexCode: .bgColor)
        
        [
            storeNameLabel,
            rateImageView,
            rateLabel,
            userRateCountLabel,
            storeTypeLabel,
            addressLabel,
            timeImageView,
            openNowLabel,
            separatorView,
            storeImageView
        ].forEach { contentView.addSubview($0) }
        
        // 식당명
        storeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(230)
            make.top.equalToSuperview().offset(26)
        }
        
        // 별점 이미지
        rateImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(storeNameLabel.snp.bottom).offset(7)
        }
        
        // 별점
        rateLabel.snp.makeConstraints { make in
            make.leading.equalTo(rateImageView.snp.trailing).offset(4)
            make.centerY.equalTo(rateImageView)
        }
        
        // 리뷰수
        userRateCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(rateLabel.snp.trailing).offset(4)
            make.centerY.equalTo(rateImageView)
        }
        
        // 식당 종류 - API 미 제공시 삭제 예정
        storeTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(userRateCountLabel.snp.trailing).offset(4)
            make.centerY.equalTo(rateImageView)
        }
        
        // 주소
        addressLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(rateLabel.snp.bottom).offset(4)
            make.width.equalTo(230)
        }
        
        // 시계 이미지
        timeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
        }
        
        // 영업전/후 • 시간
        openNowLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImageView.snp.trailing).offset(4)
            make.centerY.equalTo(timeImageView)
        }
        
        // 구분선
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        // 식당 이미지
        storeImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.248)
            make.height.equalTo(storeImageView.snp.width)
            make.top.equalToSuperview().offset(26)
        }
    }
    
    
    // MARK: - UI 변경 함수 부분 -
    // 추후에 UI를 변경할 때 사용
    func configureView(with storeInfo: StoreInfo) {
        var address = storeInfo.formattedAddress
        if address.hasPrefix("대한민국 ") {
            address = String(address.dropFirst("대한민국 ".count))
        }
        address = address.replacingOccurrences(of: "서울특별시", with: "서울시")
        
        let openInfo = storeInfo.currentOpeningHours
        let openInfoText = OpeningHours.getTodayClosingOrTomorrowOpening(openingHours: openInfo) 
        
        storeNameLabel.attributedText = AttributedStringManager.configureString(
            text: storeInfo.displayName,
            font: .customFontForHeader(weight: .w800),
            color: .neutral950,
            lineBreak: .byTruncatingTail
        )
        
        rateLabel.attributedText = AttributedStringManager.configureString(
            text: "\(storeInfo.rating)",
            font: .customFontForBody(weight: .w600),
            color: .neutral800
        )
        
        userRateCountLabel.attributedText = AttributedStringManager.configureString(
            text: "(\(storeInfo.userRatingCount))",
            font: .customFontForBody(weight: .w600),
            color: .neutral800
        )
        
        addressLabel.attributedText = AttributedStringManager.configureString(
            text: address,
            font: .customFontForBody(weight: .w500),
            color: .neutral700,
            lineBreak: .byTruncatingTail
        )
        
        storeTypeLabel.attributedText = AttributedStringManager.configureString(
            text: storeInfo.primaryTypeDisplayName,
            font: .customFontForBody(weight: .w500),
            color: .neutral700
        )
        
        if storeInfo.currentOpeningHours.openNow {
            openNowLabel.attributedText = AttributedStringManager.configureString(
                text: "영업 중" + " • \(openInfoText)",
                font: .customFontForBody(weight: .w500),
                color: .neutral700
            )
        } else {
            openNowLabel.attributedText = AttributedStringManager.configureHighlightString(
                text: "영업 종료" + " • \(openInfoText)",
                font: .customFontForBody(weight: .w500),
                color: .neutral700,
                highlightWords: [
                    .init(word: "영업 종료", color: .closedColor)
                ]
            )
        }
        
        // photoNames이 빈문자열이면 DefaultImage 표시
        if storeInfo.photosNames != "DefaultImage" {
            if let url = URL(string: storeInfo.photosNames) {
                storeImageView.kf.setImage(with: url)
            }
        } else {
            storeImageView.image = UIImage(named: "DefaultImage")
        }
    }
}
