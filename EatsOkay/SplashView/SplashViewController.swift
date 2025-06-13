//
//  SplashViewController.swift
//  EatsOkay
//
//  Created by 김기태 on 6/12/25.
//

import UIKit
import SnapKit

final class SplashViewController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupUI() {
        [backgroundImageView, logoImageView]
            .forEach { view.addSubview($0) }
        
        backgroundImageView.image = .splashBackground
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        logoImageView.image = .splashLogo
    }
}


