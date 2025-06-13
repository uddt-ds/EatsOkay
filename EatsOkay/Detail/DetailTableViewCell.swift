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
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "식당명"
        label.textColor = .customColor(hexCode: .neutral950)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .customFontForHeader(weight: .w800)
        return label
    }()
    
    private let rateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Star")
        return imageView
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.textColor = .customColor(hexCode: .neutral800)
        label.font = .customFontForBody(weight: .w600)
        return label
    }()
    
    private let userRateCountLabel: UILabel = {
        let label = UILabel()
        label.text = "(리뷰수)"
        label.textColor = .customColor(hexCode: .neutral800)
        label.font = .customFontForBody(weight: .w600)
        return label
    }()
    
    private let storeTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "식당 종류"
        label.textColor = .customColor(hexCode: .neutral700)
        label.font = .customFontForBody(weight: .w500)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "주소"
        label.textColor = .customColor(hexCode: .neutral700)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .customFontForBody(weight: .w500)
        return label
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Time")
        return imageView
    }()
    
    private let openNowLabel: UILabel = {
        let label = UILabel()
        label.text = "영업전/후 • 시간"
        label.textColor = .customColor(hexCode: .neutral700)
        label.numberOfLines = 0
        label.font = .customFontForBody(weight: .w500)
        return label
    }()
    
    private let storeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle")
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .customColor(hexCode: .neutral50)
        return view
    }()
    
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
        
        [storeNameLabel, rateImageView, rateLabel, userRateCountLabel, storeTypeLabel, addressLabel, timeImageView, openNowLabel, separatorView, storeImageView].forEach {
            contentView.addSubview($0)
        }
        
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
        let openInfoText = getTodayClosingOrTomorrowOpening(openingHours: openInfo)
        
        storeNameLabel.text = storeInfo.displayName
        rateLabel.text = "\(storeInfo.rating)"
        userRateCountLabel.text = "(\(storeInfo.userRatingCount))"
        addressLabel.text = address
        storeTypeLabel.text = storeInfo.primaryTypeDisplayName
        openNowLabel.text = storeInfo.currentOpeningHours.openNow ? "영업중" + " • \(openInfoText)" : "영업 종료" + " • \(openInfoText)"
        storeImageView.image = UIImage(named: "DefaultImage")
    }
}

extension DetailTableViewCell {
    // 오늘의 영업 종료 시간과 내일의 영업 시작 시간을 구하는 함수
    func getTodayClosingOrTomorrowOpening(openingHours: OpeningHours) -> String {
        let calendar = Calendar.current
        let now = Date()
        // 현재 1=일요일, 7=토요일를  0=일요일, 6=토요일 형태로 변환
        let todayWeekday = (calendar.component(.weekday, from: now) + 6) % 7

        // 오늘 날짜와 요일에 해당하는 periods 추출
        let todayPeriods = openingHours.periods.filter { $0.open.day == todayWeekday }

        if openingHours.openNow {
            // 오늘의 마지막 close 시간 찾기
            guard let lastPeriod = todayPeriods.max(by: { lhs, rhs in
                let lhsValue = lhs.close.hour * 60 + lhs.close.minute
                let rhsValue = rhs.close.hour * 60 + rhs.close.minute
                return lhsValue < rhsValue
            }) else { return "" }
            return String(format: "%02d:%02d 영업 종료", lastPeriod.close.hour, lastPeriod.close.minute)
        } else {
            // 내일 요일 계산
            let tomorrowWeekday = (todayWeekday + 1) % 7
            let tomorrowPeriods = openingHours.periods.filter { $0.open.day == tomorrowWeekday }
            guard let firstPeriod = tomorrowPeriods.min(by: { lhs, rhs in
                let lhsValue = lhs.open.hour * 60 + lhs.open.minute
                let rhsValue = rhs.open.hour * 60 + rhs.open.minute
                return lhsValue < rhsValue
            }) else { return "" }
            return String(format: "%02d:%02d 영업 시작", firstPeriod.open.hour, firstPeriod.open.minute)
        }
    }
    
}
