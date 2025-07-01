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
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradationView = GradationView()
    private let startButton = CustomButton(title: "시작하기")
    private let contentView = UIView()
    private let contentViews: [UIView] = [
        UIView(), UIView(), UIView()
    ]
    
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(backgroundImageView)
        contentViews.forEach { contentView.addSubview($0) }
        
        [
            titleView,
            descriptionLabel,
            pageControl,
            imageView,
            gradationView,
            startButton
        ]
            .forEach { view.addSubview($0) }
        
        titleView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(contentViews.count)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(UIScreen.main.bounds.height*0.1)
        }
        
        for (index, view) in contentViews.enumerated() {
            view.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(scrollView.snp.width)
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(contentViews[index - 1].snp.trailing)
                }
            }
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.height.equalTo(38)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(68)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(10.33)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        gradationView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        startButton.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(60)
            $0.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func bind(reactor: Reactor) {
        
        scrollView.rx.contentOffset
            .withUnretained(self)
            .map { vc, offset -> Int in
                let pageWidth = vc.scrollView.frame.width
                guard pageWidth > 0, offset.x.isFinite else { return 0 }
                return Int(round(offset.x / pageWidth))
            }
            .distinctUntilChanged()
            .map(Reactor.Action.scrollAction)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.pages.count }
            .distinctUntilChanged()
            .bind(to: pageControl.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.currentPage }
            .distinctUntilChanged()
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.currentPageModel }
            .distinctUntilChanged { $0.title == $1.title }
            .subscribe(onNext: { [weak self] page in
                guard let self = self else { return }
                UIView.transition(with: self.titleLabel, duration: 0, options: .transitionCrossDissolve, animations: {
                    self.titleLabel.attributedText = AttributedStringManager.configureString(
                        text: page.title,
                        font: .customFontForSubtitle(weight: .w700),
                        color: .neutral950
                    )
                })
                
                UIView.transition(with: self.descriptionLabel, duration: 0, options: .transitionCrossDissolve, animations: {
                    self.descriptionLabel.attributedText = AttributedStringManager.configureString(
                        text: page.description,
                        font: .customFontForHeader(weight: .w950),
                        color: .neutral950,
                        alignment: .center
                    )
                })
                
                UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = UIImage(named: page.imageName)
                })
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
        
        reactor.state
            .compactMap { $0.isCompleted }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToLocationSelectView()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToLocationSelectView() {
        let reactor = LocationReactor()
        let locationVC = LocationViewController(reactor: reactor)
        self.navigationController?.setViewControllers([locationVC], animated: true)
    }
}


final class GradationView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
}
