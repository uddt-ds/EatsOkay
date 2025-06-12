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
    private let titleLabel = UILabel()
    private let hashTagLabel = UILabel()
    private let backgroundImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setContraints()
        contentView.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.backgroundColor = .white.withAlphaComponent(0.8)

        [titleLabel, hashTagLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }

        [backgroundImageView, tagLabel, titleStackView].forEach {
            contentView.addSubview($0)
        }

        backgroundImageView.backgroundColor = .gray   //테스트용 컬러
        backgroundImageView.layer.cornerRadius = 12
        backgroundImageView.clipsToBounds = true

        titleStackView.isLayoutMarginsRelativeArrangement = true
        titleStackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        titleStackView.axis = .vertical
        titleStackView.spacing = 4
        titleStackView.distribution = .equalCentering
        titleStackView.alignment = .leading
        titleStackView.backgroundColor = .white.withAlphaComponent(0.8)

        titleLabel.font = .customFontForHeader(weight: .w800)
        hashTagLabel.font = .customFontForBody(weight: .w600)
        tagLabel.font = .customFontForBody(weight: .w400)
        tagLabel.backgroundColor = .customColor(hexCode: .neutral700)
        tagLabel.textColor = .white

        tagLabel.textAlignment = .center
        tagLabel.layer.cornerRadius = 8
        tagLabel.clipsToBounds = true
    }

    private func setContraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
        }

        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.top).offset(20)
            make.trailing.equalTo(backgroundImageView.snp.trailing).offset(-20)
            make.width.equalTo(41)
            make.height.equalTo(25)
        }

        titleStackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(backgroundImageView)
        }
    }

    func configureCell(data: SectionData) {
        titleLabel.text = data.title
        hashTagLabel.text = "\(data.hashTags[0]) \(data.hashTags[1])"
        tagLabel.text = data.category.title
    }
}
