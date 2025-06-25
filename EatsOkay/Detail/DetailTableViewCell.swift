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
        let view = CustomSeparator(color: .neutral50)
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
        
        contentView.backgroundColor = .customColor(hexCode: .bgColor)
        
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
        
        // photoNames이 빈문자열이면 DefaultImage 표시
        if storeInfo.photosNames != "" {
            if let url = URL(string: storeInfo.photosNames) {
                storeImageView.kf.setImage(with: url)
            }
        } else {
            storeImageView.image = UIImage(named: "DefaultImage")
        }
    }
}

extension DetailTableViewCell {
    func getTodayClosingOrTomorrowOpening(openingHours: OpeningHours) -> String {
        let calendar = Calendar.current
        let now = Date()
        // 0=일요일, 6=토요일
        let todayWeekday = (calendar.component(.weekday, from: now) + 6) % 7
        let tomorrowWeekday = (todayWeekday + 1) % 7
        let nowHour = calendar.component(.hour, from: now)
        let nowMinute = calendar.component(.minute, from: now)
        let nowMinutes = nowHour * 60 + nowMinute

        // 24시간 영업 감지 (periods에 0:00~23:59이거나 weekdayDescriptions에 "24시간" 포함)
        let isAlwaysOpen = openingHours.periods.contains {
            $0.open.hour == 0 && $0.open.minute == 0 &&
            $0.close.hour == 23 && $0.close.minute == 59 &&
            $0.open.day == $0.close.day
        } || (openingHours.weekdayDescriptions?.contains(where: { $0.contains("24시간") }) ?? false)
        if isAlwaysOpen {
            return "24시간 영업"
        }

        // 오늘 요일에 해당하는 periods 추출
        let todayPeriods = openingHours.periods.filter { $0.open.day == todayWeekday }
        // 내일 요일에 해당하는 periods 추출
        let tomorrowPeriods = openingHours.periods.filter { $0.open.day == tomorrowWeekday }

        // 오늘 새벽(0~6시): 어제 오픈, 오늘 클로즈 period를 찾아야 함
        if nowHour < 6 {
            let yesterdayWeekday = (todayWeekday + 6) % 7
            if let period = openingHours.periods.first(where: {
                $0.open.day == yesterdayWeekday && $0.close.day == todayWeekday
            }) {
                let closeMinutes = period.close.hour * 60 + period.close.minute
                if nowMinutes < closeMinutes {
                    if period.close.hour < 6 {
                        return String(format: "새벽 %02d:%02d 영업 종료", period.close.hour, period.close.minute)
                    } else {
                        return String(format: "%02d:%02d 영업 종료", period.close.hour, period.close.minute)
                    }
                }
            }
        }

        // 오늘 영업 중일 때
        if openingHours.openNow {
            var todayCloseTimes: [(Int, Int)] = []
            for period in todayPeriods {
                if period.close.day == todayWeekday {
                    todayCloseTimes.append((period.close.hour, period.close.minute))
                }
            }
            var midnightCloseTimes: [(Int, Int)] = []
            for period in todayPeriods {
                if period.close.day == tomorrowWeekday {
                    midnightCloseTimes.append((period.close.hour, period.close.minute))
                }
            }
            let allCloseTimes = todayCloseTimes + midnightCloseTimes
            if let close = allCloseTimes
                .filter({ hour, minute in
                    let closeMinutes = hour * 60 + minute
                    return closeMinutes > nowMinutes || (hour < 6 && closeMinutes < nowMinutes)
                })
                .min(by: { lhs, rhs in
                    let lhsValue = lhs.0 * 60 + lhs.1
                    let rhsValue = rhs.0 * 60 + rhs.1
                    return lhsValue < rhsValue
                }) {
                if close.0 < 6 {
                    return String(format: "새벽 %02d:%02d 영업 종료", close.0, close.1)
                } else {
                    return String(format: "%02d:%02d 영업 종료", close.0, close.1)
                }
            }
        }

        // 오늘 요일의 오픈 시간 중, 현재 시간보다 큰(아직 오픈 전) 가장 가까운 오픈 시간 찾기
        let todayOpenTimes = todayPeriods.map { ($0.open.hour, $0.open.minute) }
        if let nextOpen = todayOpenTimes
            .filter({ hour, minute in hour * 60 + minute > nowMinutes })
            .min(by: { lhs, rhs in lhs.0 * 60 + lhs.1 < rhs.0 * 60 + rhs.1 }) {
            // 오늘 영업이 있고, 내일이 휴무인데 아직 오픈 시간 전이면 오늘 오픈 시간 표시
            if tomorrowPeriods.isEmpty {
                return String(format: "%02d:%02d 영업 시작", nextOpen.0, nextOpen.1)
            } else {
                return String(format: "%02d:%02d 영업 시작", nextOpen.0, nextOpen.1)
            }
        }

        // 오늘 영업이 없고, 내일이 휴무인 경우
        if tomorrowPeriods.isEmpty {
            // 오늘 영업이 없고, 내일도 영업이 없음 (연속 휴무)
            let nowHour = calendar.component(.hour, from: now)
            // 오후 10시(22시) 이전이면 "오늘 휴무", 이후면 "다음날 휴무"
            if nowHour < 22 {
                return "오늘 휴무"
            } else {
                return "다음날 휴무"
            }
        } else {
            // 내일 영업 시간이 있으면 내일 첫 번째 오픈 시간 표시
            if let firstPeriod = tomorrowPeriods.min(by: {
                ($0.open.hour * 60 + $0.open.minute) < ($1.open.hour * 60 + $1.open.minute)
            }) {
                return String(format: "%02d:%02d 영업 시작", firstPeriod.open.hour, firstPeriod.open.minute)
            }
        }
        return ""
    }
}



