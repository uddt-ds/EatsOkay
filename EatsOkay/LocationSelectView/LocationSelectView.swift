//
//  LocationSelectView.swift
//  EatsOkay
//
//  Created by LCH on 6/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

final class LocationSelectView: UIViewController {
    
    let guideLabel: UILabel = {
        
        let titleText = NSMutableAttributedString(
            string: "어디에 계신가요?\n지역을 골라주세요!"
        )
        
        let range = NSRange(location: 0, length: titleText.length)
        
        let headerFont = UIFont.customFontForHeader(weight: .w950)
        let textColor = UIColor.customColor(hexCode: .neutral950)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        textStyle.lineHeightMultiple = 1.17
        
        titleText.addAttribute(.font, value: headerFont, range: range)
        titleText.addAttribute(.foregroundColor, value: textColor, range: range)
        titleText.addAttribute(.paragraphStyle, value: textStyle, range: range)
        
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = titleText
        
        return label
    }()
    
    let locationButton: UIButton = {
        
        let titleText = NSMutableAttributedString(string: "현재 위치로 설정")
        let range = NSRange(location: 0, length: titleText.length)
        
        let headerFont = UIFont.customFontForSubtitle(weight: .w600)
        let textColor = UIColor.customColor(hexCode: .neutral400)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        textStyle.lineHeightMultiple = 1.17
        
        titleText.addAttribute(.font, value: headerFont, range: range)
        titleText.addAttribute(.foregroundColor, value: textColor, range: range)
        titleText.addAttribute(.paragraphStyle, value: textStyle, range: range)
        
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(resource: .locationMark)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4
        configuration.contentInsets = .zero
        configuration.attributedTitle = AttributedString(titleText)
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private lazy var textStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
            guideLabel,
            locationButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    let startButton = CustomButton(title: "설정하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    private func configureUI() {
        
        view.backgroundColor = .customColor(hexCode: .bgColor)
        
        [
            pickerView,
            textStackView,
            startButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        guideLabel.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).inset(20)
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            $0.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(20)
        }
        
        pickerView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(20)
            $0.center.equalTo(view.snp.center)
        }
        
        startButton.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(60)
            $0.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
}
