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
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .background
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.customColor(hexCode: .primary400)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let titleView: UIView = {
        let titleView = UIView()
        titleView.backgroundColor = UIColor.customColor(hexCode: .primary50)
        titleView.layer.cornerRadius = 8
        return titleView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let gradationView = GradationView()
    private let startButton = CustomButton(title: "시작하기")
    
    private lazy var contentViews: [UIView] = [
        UIView(), UIView(), UIView()
    ]
    
    private let reactor = OnboardingReactor()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        addContentToScrollView()
        bind(reactor: reactor)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [scrollView, titleView, titleLabel, descriptionLabel, pageControl, imageView, gradationView, startButton].forEach {
            view.addSubview($0)
        }
        
        titleView.addSubview(titleLabel)
        scrollView.addSubview(backgroundImageView)
    }
    
    private func addContentToScrollView() {
        for i in 0..<contentViews.count {
            let view = contentViews[i]
            view.backgroundColor = .clear
            view.frame = CGRect(
                x: UIScreen.main.bounds.width * CGFloat(i),
                y: 0,
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            )
            scrollView.addSubview(view)
        }
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(contentViews.count),
            height: UIScreen.main.bounds.height
        )
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
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
        
        gradationView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(121)
        }
        
        startButton.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(60)
            $0.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func bind(reactor: Reactor) {
        reactor.action.onNext(.viewDidLoad)
        
        //  Rx로 스크롤 이벤트 감지 & NaN 방지
        scrollView.rx.contentOffset
            .map { [weak self] offset -> Int in
                guard let self = self else { return 0 }
                let pageWidth = self.scrollView.frame.width
                guard pageWidth > 0, offset.x.isFinite else { return 0 }
                return Int(round(offset.x / pageWidth))
            }
            .distinctUntilChanged()
            .map(Reactor.Action.scrollAction)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pages.count }
            .distinctUntilChanged()
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPage }
            .distinctUntilChanged()
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPageModel }
            .distinctUntilChanged { $0.title == $1.title }
            .subscribe(onNext: { [weak self] page in
                self?.titleLabel.attributedText = self?.setTitle(text: page.title)
                self?.descriptionLabel.attributedText = self?.setDescription(text: page.description)
                self?.imageView.image = UIImage(named: page.imageName)
            })
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .map { Reactor.Action.startButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !($0.currentPage == $0.pages.count - 1) }
            .distinctUntilChanged()
            .bind(to: startButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isCompleted }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToMain()
            })
            .disposed(by: disposeBag)
    }
    
    private func setTitle(text: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attr.length)
        let font = UIFont.customFontForSubtitle(weight: .w700)
        let color = UIColor.customColor(hexCode: .neutral950)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineHeightMultiple = 1.17
        attr.addAttributes([.font: font, .foregroundColor: color, .paragraphStyle: paragraph], range: range)
        return attr
    }
    
    private func setDescription(text: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attr.length)
        let font = UIFont.customFontForHeader(weight: .w950)
        let color = UIColor.customColor(hexCode: .neutral950)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineHeightMultiple = 1.17
        attr.addAttributes([.font: font, .foregroundColor: color, .paragraphStyle: paragraph], range: range)
        return attr
    }
    
    private func navigateToMain() {
        print("온보딩 완료 -> 메인으로 이동")
    }
}

final class GradationView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
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
