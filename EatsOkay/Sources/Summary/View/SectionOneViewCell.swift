//
//  SectionOneViewCell.swift
//  EatsOkay
//
//  Created by 허성필 on 6/30/25.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class SectionOneViewCell: UICollectionViewCell {
    static let identifier = "SectionOneViewCell"
    
    fileprivate let contentsButtonRelay = PublishRelay<Void>()
    var disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .customColor(hexCode: .bgColor)
        return view
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    let photoPageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.customColor(hexCode: .neutral950).withAlphaComponent(0.6)
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()
    
    private let storeImageView = UIView()
    private let contentButtons: [UIButton] = {
        ["DefaultImage", "DefaultImage", "DefaultImage"].map { imageName in
            let button = UIButton()
            button.imageView?.contentMode = .scaleAspectFit
            return button
        }
    }()
    
    private func configureUI() {
        contentView.backgroundColor = .white
        scrollView.addSubview(bgView)
        scrollView.addSubview(storeImageView)
        
        
        contentButtons.forEach { storeImageView.addSubview($0) }
        
        [
            scrollView, photoPageLabel
        ]
            .forEach { contentView.addSubview($0) }
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        storeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(contentButtons.count)
        }
        
        bgView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height)
        }
        
        for (index, view) in contentButtons.enumerated() {
            view.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.width.equalTo(scrollView.snp.width)
                if index == 0 {
                    $0.leading.equalToSuperview()
                } else {
                    $0.leading.equalTo(contentButtons[index - 1].snp.trailing)
                }
            }
        }
        
        photoPageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.width.equalTo(45)
            make.height.equalTo(26)
        }
        
    }
    
    func update(with: SummarySectionModel.CellModel) {
        switch with {
        case .summaryImageCell(let data):
            contentButtons.forEach {
                $0.rx.tap
                    .withUnretained(self)
                    .bind { cell, _ in
                        cell.contentsButtonRelay.accept(Void())
                    }
                    .disposed(by: disposeBag)
            }
            for (index, urlString) in data.photosUrl.enumerated() {
                if index < contentButtons.count {
                    if let url = URL(string: urlString) {
                        contentButtons[index].kf.setImage(with: url, for: .normal)
                        contentButtons[index].kf.setImage(with: url, for: .highlighted)
                    } else {
                        contentButtons[index].setImage(UIImage(named: "DefaultImage"), for: .normal)
                        contentButtons[index].setImage(UIImage(named: "DefaultImage"), for: .highlighted)
                    }
                }
            }
        default:
            break
        }
    }
}

extension Reactive where Base: SectionOneViewCell {
    var imagePage: Observable<CGPoint> {
        return base.scrollView.rx.contentOffset
            .asObservable() 
    }
    
    var buttonsTapped: Observable<Void> {
        return base.contentsButtonRelay
            .asObservable()
    }
}

