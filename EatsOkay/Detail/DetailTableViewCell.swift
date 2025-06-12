//
//  DetailTableViewCell.swift
//  EatsOkay
//
//  Created by 허성필 on 6/9/25.
//

import UIKit
import SnapKit

class DetailTableViewCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"
    
    private let storeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "식당명"
        label.textColor = .customColor(hexCode: .neutral950)
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
    
    func setupViews() {
        
        [storeNameLabel, rateImageView, rateLabel, userRateCountLabel, storeTypeLabel, addressLabel, timeImageView, openNowLabel, separatorView, storeImageView].forEach {
            contentView.addSubview($0)
        }
        
        // 식당명
        storeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
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
            make.top.equalToSuperview().offset(26)
        }
    }
    
    // 추후에 UI를 변경할 때 사용
    func configureView(with storeInfo: StoreInfo) {
        storeNameLabel.text = storeInfo.displayName
        rateLabel.text = "\(storeInfo.rating)"
        userRateCountLabel.text = "(\(storeInfo.userRatingCount))"
        addressLabel.text = storeInfo.formattedAddress
//        openNowLabel.text =
    }
}
