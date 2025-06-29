//
//  BlackBackgroundView.swift
//  EatsOkay
//
//  Created by Lee on 6/29/25.
//

import UIKit

class BlackBackgroundView: UICollectionReusableView {
    private let blackBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(blackBgView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        blackBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

