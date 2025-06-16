//
//  OnBoardingViewController.swift
//  EatsOkay
//
//  Created by 김기태 on 6/9/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

final class OnboardingViewController: UIViewController, View {
    typealias Reactor = OnboardingReactor
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customColor(hexCode: .primary50)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        
        label.clipsToBounds = true
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.customColor(hexCode: .primary400)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    private let gradationView = GradationView()
    
    private let reactor = OnboardingReactor()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        bind(reactor: reactor)
        
    }
    
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [titleView, descriptionLabel, pageControl, imageView, nextButton, gradationView].forEach {
            view.addSubview($0)
        }
        titleView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }

        gradationView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(121)
        }
    }
    
    private func setTitle(text: String) -> NSMutableAttributedString {
        let atString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: atString.length)
        let font = UIFont.customFontForSubtitle(weight: .w700)
        let color = UIColor.customColor(hexCode: .neutral950)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.17
        
        atString.addAttribute(.font, value: font, range: range)
        atString.addAttribute(.foregroundColor, value: color, range: range)
        atString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return atString
    }
    
    private func setDescription(text: String) -> NSMutableAttributedString {
        let atString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: atString.length)
        let font = UIFont.customFontForHeader(weight: .w950)
        let color = UIColor.customColor(hexCode: .neutral950)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.17
        
        atString.addAttribute(.font, value: font, range: range)
        atString.addAttribute(.foregroundColor, value: color, range: range)
        atString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        return atString
    }
    
    private func navigateToMain() {
        // 메인 화면 전환 처리
        print("온보딩 완료 -> 메인 화면으로 이동")
    }
}

extension OnboardingViewController {
    func bind(reactor: Reactor) {
        // Action: 최초 진입
        reactor.action.onNext(.viewDidLoad)
        
        // Action: 다음 버튼 탭
        nextButton.rx.tap
            .map { .nextTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State → UI 바인딩
        reactor.state.map { $0.currentPageModel }
            .distinctUntilChanged { $0.title == $1.title }
            .subscribe(onNext: { [weak self] page in
                self?.titleLabel.attributedText = self?.setTitle(text: page.title)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPageModel }
            .distinctUntilChanged { $0.description == $1.description }
            .subscribe(onNext: { [weak self] page in
                self?.descriptionLabel.attributedText = self?.setDescription(text: page.description)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { UIImage(named: $0.currentPageModel.imageName) }
            .distinctUntilChanged { $0 == $1 }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentButtonTitle }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPage }
            .distinctUntilChanged()
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pages.count }
            .distinctUntilChanged()
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isCompleted }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToMain()
            })
            .disposed(by: disposeBag)
    }

}

final class GradationView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false   // 터치 방지
        gradientLayer.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.addSublayer(gradientLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
