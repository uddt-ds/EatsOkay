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

final class LocationSelectView: UIViewController, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    let reactor: LocationSelectReactor
    
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
    
    init(reactor: LocationSelectReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        bind(reactor: reactor)
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
    
    func bind(reactor: LocationSelectReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: LocationSelectReactor) {
        Observable.just(Void())
            .map { Reactor.Action.initialFetch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        locationButton.rx.tap
            .map { Reactor.Action.locationButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pickerView.rx.itemSelected
            .map { Reactor.Action.pickerViewChanged(component: $0.component, row: $0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: LocationSelectReactor) {
        reactor.pulse(\.$pickerViewData)
            .map { $0 as PickerViewAdapter.Element }
            .bind(to: pickerView.rx.items(adapter: PickerViewAdapter()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pickerViewinitialRows)
            .withUnretained(self)
            .bind { vc, rows in
                guard let rows else { return }
                vc.pickerView.selectRow(rows.firstRow, inComponent: 0, animated: true)
                vc.pickerView.selectRow(rows.secondRow, inComponent: 1, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertState)
            .withUnretained(self)
            .bind { vc, void in
                guard void != nil else { return }
                let locationAlert = CustomLocationAlert()
                vc.present(locationAlert, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$nextViewState)
            .withUnretained(self)
            .bind { vc, test in
                guard test != nil else { return }
                let testView = MainViewController()
                vc.present(testView, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .withUnretained(self)
            .bind { vc, error in
                guard error != nil else { return }
                guard let errorString = error?.localizedDescription else { return }
                print(errorString)
            }
            .disposed(by: disposeBag)
    }
}
