//
//  cardSectionsCell.swift
//  EatsOkay
//
//  Created by Lee on 6/10/25.
//

import UIKit

final class CardSectionsCell: UITableViewCell {
    private let tagLabel = UILabel()
    private let titleStackView = UIStackView()
    private let stackBgView = UIView()
    private let titleLabel = UILabel()
    private let hashTagLabel = UILabel()
    private let backgroundImageView = UIImageView()
    private let shadowBackgroundView = UIView()

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
        contentView.backgroundColor = .white.withAlphaComponent(0.8)

        [titleLabel, hashTagLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }

        stackBgView.addSubview(titleStackView)

        [shadowBackgroundView, tagLabel, stackBgView].forEach {
            contentView.addSubview($0)
        }

        shadowBackgroundView.addSubview(backgroundImageView)

        shadowBackgroundView.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0.08)
        shadowBackgroundView.layer.shadowOpacity = 1.0
        shadowBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowBackgroundView.layer.shadowRadius = 20
        shadowBackgroundView.layer.masksToBounds = false

        backgroundImageView.layer.cornerRadius = 12
        backgroundImageView.clipsToBounds = true

        titleStackView.isLayoutMarginsRelativeArrangement = true
        titleStackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        titleStackView.axis = .vertical
        titleStackView.spacing = 4
        titleStackView.distribution = .equalCentering
        titleStackView.alignment = .leading
        titleStackView.backgroundColor = .clear

        stackBgView.backgroundColor = .white.withAlphaComponent(0.8)
        stackBgView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        stackBgView.layer.cornerRadius = 12

        tagLabel.backgroundColor = .customColor(hexCode: .neutral700)
        tagLabel.layer.cornerRadius = 8
        tagLabel.clipsToBounds = true
    }

    private func setContraints() {
        shadowBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
        }

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.top).offset(20)
            make.trailing.equalTo(backgroundImageView.snp.trailing).offset(-20)
            make.width.equalTo(41)
            make.height.equalTo(25)
        }

        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackBgView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(backgroundImageView)
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
                text: "\(data.hashTags[0]) \(data.hashTags[1])",
                font: .customFontForBody(weight: .w600),
                color: .neutral700
            )

        let taggingLabel: NSAttributedString = AttributedStringManager
            .configureString(
                text: data.category.title,
                font: .customFontForBody(weight: .w400),
                color: .bgColor,
                alignment: .center
            )

        titleLabel.attributedText = labelText
        hashTagLabel.attributedText = hashLabel
        tagLabel.attributedText = taggingLabel
        backgroundImageView.image = data.assetImage
    }
}

