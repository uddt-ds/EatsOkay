//
//  CategoryBtnStackView.swift
//  EatsOkay
//
//  Created by Lee on 6/12/25.
//

import UIKit
import RxCocoa
import RxSwift

class CategoryBtnView: UIView {

    private var disposeBag = DisposeBag()

    let selectedIndex = BehaviorRelay<Int>(value: 0)

    private let scrollView = UIScrollView()
    private let btnStackView = UIStackView()
    private var buttons: [UIButton] = []
    private let buttonTitles = ["전체", "일상", "운동", "직장", "연애", "계절"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtons()
        configureUI()
        setConstraints()
        selectButton(index: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setButtons() {
        // enumerated로 튜플(index, value)로 만들어서 태그를 추가함
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.customColor(hexCode: .neutral700), for: .normal)
            button.backgroundColor = .customColor(hexCode: .neutral50)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
            button.layer.cornerRadius = 12
            button.titleLabel?.font = .customFontForSubtitle(weight: .w600)

            button.tag = index

            button.snp.makeConstraints {
                $0.width.equalTo(80)
                $0.height.equalTo(40)
            }

            button.rx.tap
                .withUnretained(self)
                .asDriver(onErrorDriveWith: .empty())
                .drive { btnView, _ in
                    btnView.selectButton(index: index)
                    btnView.selectedIndex.accept(index)
                }
                .disposed(by: disposeBag)

            buttons.append(button)
            btnStackView.addArrangedSubview(button)
        }
    }

    private func configureUI() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.backgroundColor = .white

        btnStackView.axis = .horizontal
        btnStackView.spacing = 8
        btnStackView.alignment = .fill
        btnStackView.distribution = .fill

        [scrollView].forEach { self.addSubview($0) }
        scrollView.addSubview(btnStackView)

        scrollView.isPagingEnabled = true

        let shadowLayer = CALayer()
        shadowLayer.frame = CGRect(
            x: 0,
            y: 72,
            width: UIScreen.main.bounds.width,
            height: 2
        )
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.08
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowRadius = 20
        shadowLayer.shadowPath = UIBezierPath(rect: shadowLayer.bounds).cgPath

        scrollView.layer.addSublayer(shadowLayer)
    }

    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

        btnStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(16)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-16)
            make.leading.equalTo(scrollView.snp.leading).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    /**
     선택된 버튼의 색상과 폰트컬러를 바꿔주는 메서드입니다
     */
    private func selectButton(index: Int) {
        for (i, button) in buttons.enumerated() {
            let isSelected = (i == index)
            button.isSelected = isSelected
            button.backgroundColor = isSelected ?
                .customColor(hexCode: .primary400) : .customColor(hexCode: .neutral50)
            button.setTitleColor(
                isSelected ? .white : .customColor(hexCode: .neutral700),
                for: .normal
            )
        }
    }
}
