//
//  LocationViewController.swift
//  EatsOkay
//
//  Created by LCH on 6/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

final class LocationViewController: UIViewController, View {
    
    var disposeBag: DisposeBag = DisposeBag()
    private let reactor: LocationReactor
    private let panGesture = UIPanGestureRecognizer()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .chevronLeft), for: .normal)
        button.setImage(UIImage(resource: .chevronLeft), for: .highlighted)
        return button
    }()
    
    private let guideLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = AttributedStringManager.configureString(
            text: "어디에 계신가요?\n지역을 골라주세요!",
            font: .customFontForHeader(weight: .w950),
            color: .neutral950
        )
        
        return label
    }()
    
    private let locationButton: UIButton = {
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(resource: .locationMark)
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4
        configuration.contentInsets = .zero
        configuration.attributedTitle = AttributedStringManager.configureString(
                text: "현재 위치로 설정",
                font: .customFontForSubtitle(weight: .w600),
                color: .neutral400
        )
        
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
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let startButton = CustomButton(title: "설정하기")
    
    init(reactor: LocationReactor) {
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
        setGesture()
        bind(reactor: reactor)
    }
    
    private func configureUI() {
        
        view.backgroundColor = .customColor(hexCode: .bgColor)
        
        [
            backButton,
            pickerView,
            textStackView,
            startButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
            $0.size.equalTo(44)
        }
        
        guideLabel.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).inset(20)
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
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
    
    private func setGesture() {
        pickerView.addGestureRecognizer(panGesture)
    }
    
    func bind(reactor: LocationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: LocationReactor) {
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
        
        panGesture.rx.panGestureWithSimultaneousRecognition
            .filter { $0.state == .began }
            .map { _ in Reactor.Action.panGestureBegan }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: LocationReactor) {
        
        reactor.state.map { $0.pickerViewFilteredData }
            .map { $0 as PickerViewAdapter.Element }
            .bind(to: pickerView.rx.items(adapter: PickerViewAdapter()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$selectedItem)
            .withUnretained(self)
            .bind { vc, rows in
                vc.pickerView.selectRow(rows.firstRow, inComponent: 0, animated: true)
                vc.pickerView.selectRow(rows.secondRow, inComponent: 1, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pickerViewinitialRows)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, rows in
                vc.pickerView.selectRow(rows.firstRow, inComponent: 0, animated: true)
                vc.pickerView.selectRow(rows.secondRow, inComponent: 1, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$alertState)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                let locationAlert = CustomLocationAlert()
                locationAlert.modalPresentationStyle = .overFullScreen
                locationAlert.modalTransitionStyle = .crossDissolve
                vc.present(locationAlert, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$nextViewState)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                if let rootVC = vc.navigationController?.viewControllers.first {
                    switch rootVC {
                    case is HomeViewController:
                        vc.navigationController?.popViewController(animated: true)
                    default:
                        let reactor = HomeReactor()
                        let homeVC = HomeViewController(reactor: reactor)
                        vc.navigationController?.setViewControllers([homeVC], animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$backViewState)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                if let rootVC = vc.navigationController?.viewControllers.first {
                    switch rootVC {
                    case is HomeViewController:
                        vc.navigationController?.popViewController(animated: true)
                    default:
                        let reactor = HomeReactor()
                        let homeVC = HomeViewController(reactor: reactor)
                        vc.navigationController?.setViewControllers([homeVC], animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, error in
                vc.view.showToast(message: error.localizedDescription, alpha: 0.4) {
                    $0.width.lessThanOrEqualTo(vc.view).inset(20)
                    $0.bottom.equalTo(vc.view.safeAreaLayoutGuide.snp.bottom).inset(80)
                    $0.centerX.equalToSuperview()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isScrolling }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { vc, isScrolling in
                vc.startButton.isEnabled = !isScrolling
            }
            .disposed(by: disposeBag)
    }
}
