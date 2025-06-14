//
//  CustomLocationAlert.swift
//  EatsOkay
//
//  Created by LCH on 6/11/25.
//

import UIKit
import SnapKit

final class CustomLocationAlert: UIViewController {
    
    private let alertView:  UIView = {
        
        let view = UIView()
        view.backgroundColor = .customColor(hexCode: .neutral50)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        
        let text = NSMutableAttributedString(
            string: "위치정보 이용에 대한 액세스 권한이 없어요"
        )
        
        let range = NSRange(location: 0, length: text.length)
        
        let textFont = UIFont.customFontForHeader(weight: .w800)
        let textColor = UIColor.customColor(hexCode: .neutral950)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        textStyle.lineHeightMultiple = 1.17
        textStyle.lineBreakMode = .byWordWrapping
        textStyle.lineBreakStrategy = .hangulWordPriority
        
        text.addAttribute(.font, value: textFont, range: range)
        text.addAttribute(.foregroundColor, value: textColor, range: range)
        text.addAttribute(.paragraphStyle, value: textStyle, range: range)
        
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = text
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        
        let text = NSMutableAttributedString(
            string: "앱 설정으로 가서 액세스 권한을 수정 할 수 있어요. 이동하시겠어요?"
        )
        
        let range = NSRange(location: 0, length: text.length)
        
        let textFont = UIFont.customFontForBody(weight: .w500)
        let textColor = UIColor.customColor(hexCode: .neutral950)
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        textStyle.lineHeightMultiple = 1.13
        textStyle.lineBreakMode = .byWordWrapping
        textStyle.lineBreakStrategy = .hangulWordPriority
        
        text.addAttribute(.font, value: textFont, range: range)
        text.addAttribute(.foregroundColor, value: textColor, range: range)
        text.addAttribute(.paragraphStyle, value: textStyle, range: range)
        
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = text
        
        return label
    }()
    
    private let goSettingButton: UIButton = {
        
        let titleText = NSMutableAttributedString(
            string: "설정하러가기"
        )
        
        let range = NSRange(location: 0, length: titleText.length)
        
        let titleFont = UIFont.customFontForSubtitle(weight: .w700)
        let titleColor = UIColor.customColor(hexCode: .infoColor)
        
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .left
        titleStyle.lineHeightMultiple = 1.17
        
        titleText.addAttribute(.font, value: titleFont, range: range)
        titleText.addAttribute(.foregroundColor, value: titleColor, range: range)
        titleText.addAttribute(.paragraphStyle, value: titleStyle, range: range)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        configuration.attributedTitle = AttributedString(titleText)
        
        let button = UIButton(configuration: configuration)
        button.layer.borderColor = UIColor(hexCode: "3C3C43").withAlphaComponent(0.29).cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        
        let titleText = NSMutableAttributedString(
            string: "취소"
        )
        
        let range = NSRange(location: 0, length: titleText.length)
        
        let titleFont = UIFont.customFontForSubtitle(weight: .w700)
        let titleColor = UIColor.customColor(hexCode: .neutral700)
        
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .left
        titleStyle.lineHeightMultiple = 1.17
        
        titleText.addAttribute(.font, value: titleFont, range: range)
        titleText.addAttribute(.foregroundColor, value: titleColor, range: range)
        titleText.addAttribute(.paragraphStyle, value: titleStyle, range: range)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        configuration.attributedTitle = AttributedString(titleText)
        
        let button = UIButton(configuration: configuration)
        button.layer.borderColor = UIColor(hexCode: "3C3C43").withAlphaComponent(0.29).cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            messageLabel
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        addAction()
    }
    
    private func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        
        [alertView].forEach { view.addSubview($0) }
        
        [
            labelStackView,
            goSettingButton,
            cancelButton
        ].forEach { alertView.addSubview($0) }
    }
    
    private func setConstraints() {
        alertView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(52)
            $0.center.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        goSettingButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(labelStackView.snp.bottom).offset(16)
        }
        
        cancelButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(goSettingButton.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func addAction() {
        cancelButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        
        goSettingButton.addAction(UIAction(handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            self.dismiss(animated: true)
            UIApplication.shared.open(url)
        }), for: .touchUpInside)
    }
}
