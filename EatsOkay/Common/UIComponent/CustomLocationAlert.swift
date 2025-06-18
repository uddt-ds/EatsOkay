//
//  CustomLocationAlert.swift
//  EatsOkay
//
//  Created by LCH on 6/11/25.
//

import UIKit
import SnapKit

final class CustomLocationAlert: UIViewController {
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .customColor(hexCode: .neutral50)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = AttributedStringManager.configureString(
            text: "위치정보 이용에 대한\n액세스 권한이 없어요",
            font: .customFontForHeader(weight: .w800),
            color: .neutral950,
            alignment: .center
        )
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let text: NSMutableAttributedString = AttributedStringManager.configureString(
            text: "앱 설정으로 가서 액세스 권한을 수정할 수 있어요. 이동하시겠어요?",
            font: .customFontForBody(weight: .w500),
            color: .neutral950,
            alignment: .center
        )

        if let paragraphStyle = text.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle,
           let mutableStyle = paragraphStyle.mutableCopy() as? NSMutableParagraphStyle {
            
            mutableStyle.lineBreakMode = .byWordWrapping
            mutableStyle.lineBreakStrategy = .hangulWordPriority
            
            let fullRange = NSRange(location: 0, length: text.length)
            text.addAttribute(.paragraphStyle, value: mutableStyle, range: fullRange)
        }
        
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = text
        
        return label
    }()
    
    private let goSettingButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        configuration.attributedTitle = AttributedStringManager.configureString(
            text: "설정하러가기",
            font: .customFontForSubtitle(weight: .w700),
            color: .infoColor,
            alignment: .center
        )
        
        let button = UIButton(configuration: configuration)
        button.layer.borderColor = UIColor(hexCode: "3C3C43").withAlphaComponent(0.29).cgColor
        button.layer.borderWidth = 0.5
        
        button.configurationUpdateHandler = { button in
            let isHighlighted = button.isHighlighted
            button.backgroundColor = isHighlighted
            ? .customColor(hexCode: .neutral100)
            : .customColor(hexCode: .neutral50)
        }
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
        configuration.attributedTitle = AttributedStringManager.configureString(
            text: "취소",
            font: .customFontForSubtitle(weight: .w700),
            color: .neutral700,
            alignment: .center
        )
        
        let button = UIButton(configuration: configuration)
        button.layer.borderColor = UIColor(hexCode: "3C3C43").withAlphaComponent(0.29).cgColor
        button.layer.borderWidth = 0.5
        
        button.configurationUpdateHandler = { button in
            let isHighlighted = button.isHighlighted
            button.backgroundColor = isHighlighted
            ? .customColor(hexCode: .neutral100)
            : .customColor(hexCode: .neutral50)
        }
        
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
            $0.top.equalTo(labelStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(goSettingButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
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
