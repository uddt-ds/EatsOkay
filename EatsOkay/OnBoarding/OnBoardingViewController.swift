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
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let nextButton = UIButton(type: .system)
    private let pageControl = UIPageControl()
    private let reactor = OnboardingReactor()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(reactor: reactor)
        
    }
    
    func bind(reactor: Reactor) {
        // Action: 최초 진입
        reactor.action.onNext(.viewDidLoad)
        
        // Action: 다음 버튼 탭
        nextButton.rx.tap
            .map { .nextTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State → UI 바인딩
        reactor.state.map { $0.currentPageModel.title }
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPageModel.description }
            .distinctUntilChanged()
            .bind(to: descriptionLabel.rx.text)
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
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [imageView, titleLabel, descriptionLabel, nextButton, pageControl].forEach {
            view.addSubview($0)
        }
        
        imageView.contentMode = .scaleAspectFit

        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        nextButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func navigateToMain() {
        // 메인 화면 전환 처리
        print("온보딩 완료 → 메인 화면으로 이동")
    }
}
