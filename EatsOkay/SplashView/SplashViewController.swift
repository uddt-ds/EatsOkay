//
//  SplashViewController.swift
//  EatsOkay
//
//  Created by 김기태 on 6/12/25.
//

import UIKit
import SnapKit
import ReactorKit


final class SplashViewController: UIViewController, View {
    
    
    private let backgroundImageView = UIImageView()
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
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


