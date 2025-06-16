//
//  SectionOfHeaderView.swift
//  EatsOkay
//
//  Created by Lee on 6/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class LocationHeaderView: UIView {

    private let gradientView = GradientBackgroundView()

    private let topLabelStackView = UIStackView()
    private let iconImage = UIImageView()
    private let label = UILabel()

    let currentLocationLabel = UILabel()
    fileprivate let editIconButton = UIButton()
    private let locationStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {

        [iconImage, label].forEach {
            topLabelStackView.addArrangedSubview($0)
        }

        [currentLocationLabel, editIconButton].forEach {
            locationStackView.addArrangedSubview($0)
        }

        [gradientView, topLabelStackView, locationStackView].forEach {
            self.addSubview($0)
        }

        configureTopLabelStackView()
        configureLocationStackView()
    }


    private func configureTopLabelStackView() {
        iconImage.image = .headerLocation
        iconImage.tintColor = .white
        label.text = "현재 위치"
        label.font = .customFontForSubtitle(weight: .w700)
        label.sizeToFit()
        label.textColor = .white


        topLabelStackView.axis = .horizontal
        topLabelStackView.spacing = 4
    }

    private func configureLocationStackView() {
        currentLocationLabel.text = "서울 강남구"
        currentLocationLabel.font = .customFontForHeader(weight: .w900)
        currentLocationLabel.textColor = .white
        currentLocationLabel.sizeToFit()

        editIconButton.setImage(.headerEdit, for: .normal)
        editIconButton.tintColor = .white

        locationStackView.axis = .horizontal
        locationStackView.spacing = 4
        locationStackView.alignment = .center
        locationStackView.distribution = .fill
    }

    private func setConstraints() {

        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconImage.snp.makeConstraints { make in
            make.size.equalTo(24)
        }

        topLabelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(20)
        }

        locationStackView.snp.makeConstraints { make in
            make.leading.equalTo(topLabelStackView.snp.leading)
            make.bottom.equalToSuperview().offset(-16)
        }

        editIconButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
}

extension Reactive where Base: LocationHeaderView {
    var locationEditButton: ControlEvent<Void> {
        return base.editIconButton.rx.tap
    }
}
