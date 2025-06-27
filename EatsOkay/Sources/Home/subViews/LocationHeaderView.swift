//
//  SectionOfHeaderView.swift
//  EatsOkay
//
//  Created by Lee on 6/11/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LocationHeaderView: UIView {
    private let gradientView = GradientBackgroundView()

    private let iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.image = .headerLocation
        iconImage.tintColor = .white
        return iconImage
    }()

    private let label: UILabel = {
        let label = UILabel()
        let titleText: NSAttributedString = AttributedStringManager
            .configureString(
                text: "현재 위치",
                font: .customFontForSubtitle(weight: .w700),
                color: .bgColor
            )
        label.attributedText = titleText
        return label
    }()

    private lazy var topLabelStackView: UIStackView = {
        let stackView = UIStackView()

        [iconImage, label].forEach {
            stackView.addArrangedSubview($0)
        }

        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()

    let currentLocationLabel: UILabel = {
        let label = UILabel()
        let titleText: NSAttributedString = AttributedStringManager
            .configureString(
                text: "서울 강남구",
                font: .customFontForHeader(weight: .w900),
                color: .bgColor
            )

        label.attributedText = titleText
        return label
    }()

    fileprivate let editIconButton: UIButton = {
        let button = UIButton()
        button.setImage(.headerEdit, for: .normal)
        button.tintColor = .white
        return button
    }()

    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()

        [currentLocationLabel, editIconButton].forEach {
            stackView.addArrangedSubview($0)
        }

        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        [gradientView, topLabelStackView, locationStackView].forEach {
            self.addSubview($0)
        }
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
