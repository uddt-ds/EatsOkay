//
//  cardSectionsCell.swift
//  EatsOkay
//
//  Created by Lee on 6/10/25.
//

import UIKit
import RxSwift

final class CardSectionsCell: UITableViewCell {
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .customColor(hexCode: .primary400).withAlphaComponent(0.5)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()

    private let titleLabel = UILabel()
    private let hashTagLabel = UILabel()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        stackView.backgroundColor = .clear
        return stackView
    }()

    private lazy var titleStackBgView: UIView = {
        let bgView = UIView()
        bgView.addSubview(titleStackView)
        bgView.backgroundColor = .white.withAlphaComponent(0.8)
        bgView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        bgView.layer.cornerRadius = 12
        return bgView
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var shadowBackgroundView: UIView = {
        let view = UIView()
        view.addSubview(backgroundImageView)

        view.layer.shadowColor = UIColor.customColor(hexCode: .neutral950).cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setContraints()

        let width = UIScreen.main.bounds.width - 40    // 40은 좌우 제약(20씩)
        let height: CGFloat = 260 - 32       // 32는 상하 제약(16씩)
        let cgRect = CGRect(x: 0, y: 0, width: width, height: height)

        shadowBackgroundView.layer.shadowPath = UIBezierPath(
            roundedRect: cgRect,
            cornerRadius: 12
        ).cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.backgroundColor = .white

        [titleLabel, hashTagLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }

        [shadowBackgroundView, titleStackBgView, tagLabel].forEach {
            contentView.addSubview($0)
        }

    }

    private func setContraints() {
        shadowBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
        }

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleStackBgView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(backgroundImageView)
        }

        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.top).offset(20)
            make.trailing.equalTo(backgroundImageView.snp.trailing).offset(-20)
            make.width.equalTo(41)
            make.height.equalTo(25)
        }
    }

    func configureCell(data: SectionData) {
        let labelText: NSAttributedString = AttributedStringManager
            .configureString(
                text: data.title,
                font: .customFontForHeader(weight: .w800),
                color: .neutral950
            )

        let hashLabel: NSAttributedString = AttributedStringManager
            .configureString(
                text: data.hashTags.joined(separator: " "),
                font: .customFontForBody(weight: .w600),
                color: .neutral700
            )

        let taggingLabel: NSAttributedString = AttributedStringManager
            .configureString(
                text: data.category.title,
                font: .customFontForHeader(weight: .w400),
                color: .bgColor,
                alignment: .center
            )

        titleLabel.attributedText = labelText
        hashTagLabel.attributedText = hashLabel
        tagLabel.attributedText = taggingLabel
        backgroundImageView.image = UIImage(named: data.assetImage)
    }
}

