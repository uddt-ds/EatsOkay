//
//  SplashViewController.swift
//  EatsOkay
//
//  Created by 김기태 on 6/12/25.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa


final class SplashViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    typealias Reactor = SplashViewReactor
    private let reactor = SplashViewReactor()
    
    private let backgroundImageView = UIImageView()
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
        setupConstraints()
        // 리액터에게 체크 지시
        reactor.action.onNext(.initialCheck)
        bind(reactor: reactor)

    }
    
    // state 구독해서 상태값에 따라 화면전환 분기
    func bind(reactor: SplashViewReactor) {
        let isCompleted = reactor.state
            .compactMap { $0.isCompleted }
            .asDriver(onErrorDriveWith: .empty())
        
        isCompleted
            .filter{ $0 }
            .drive(with: self) { vc, _ in
                vc.goToMain()
            }
            .disposed(by: disposeBag)

        isCompleted
            .filter { $0 == false }
            .drive(with: self) { vc, _ in
                vc.goToOnboarding()
            }
            .disposed(by: disposeBag)
    }
    
    private func goToMain() {
        guard let nav = self.navigationController else { return }

        let reactor = HomeReactor()
        let homeVC = HomeViewController(reactor: reactor)

        UIView.transition(with: nav.view,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                              nav.setViewControllers([homeVC], animated: false)
                          })
    }
    private func goToOnboarding() {
        guard let nav = self.navigationController else { return }

        let onBoardingVC = OnboardingViewController()

        UIView.transition(with: nav.view,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                              nav.setViewControllers([onBoardingVC], animated: false)
                          })
    }

    private func setupUI() {
        [backgroundImageView, logoImageView]
            .forEach { view.addSubview($0) }
        
        backgroundImageView.image = .splashBackground
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        logoImageView.image = .splashLogo
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(137.5)
            $0.height.equalTo(logoImageView.snp.width)
            
        }
    }
}


