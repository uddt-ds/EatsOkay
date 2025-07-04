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

final class SectionOneViewCell: UICollectionViewCell {
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
    
    private let photoPageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.customColor(hexCode: .neutral950).withAlphaComponent(0.6)
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()
    
    private let storeImageView = UIView()
    
    private func configureUI() {
        contentView.backgroundColor = .white
        scrollView.addSubview(bgView)
        scrollView.addSubview(storeImageView)
        
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
        }
        
        bgView.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height)
        }
        
        photoPageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.width.equalTo(45)
            make.height.equalTo(26)
        }
        
    }
    
    func update(with: SummarySectionModel.CellModel) {
        storeImageView.subviews.forEach { $0.removeFromSuperview() }
        switch with {
        case .summaryImageCell(let data):
            
            let contentsButtons = data.photosUrl.map { uri in
                let button = UIButton()
                button.imageView?.contentMode = .scaleAspectFit
                
                if let uri = URL(string: uri) {
                    button.kf.setImage(with: uri, for: .normal, completionHandler:  { response in
                        if case .failure = response {
                            button.setImage(UIImage(named: "DefaultImage"), for: .normal)
                        }
                    })
                    button.kf.setImage(with: uri, for: .highlighted, completionHandler:  { response in
                        if case .failure = response {
                            button.setImage(UIImage(named: "DefaultImage"), for: .highlighted)
                        }
                    })
                } else {
                    button.setImage(UIImage(named: "DefaultImage"), for: .normal)
                    button.setImage(UIImage(named: "DefaultImage"), for: .highlighted)
                }
                
                button.rx.tap
                    .withUnretained(self)
                    .bind { cell, _ in
                        cell.contentsButtonRelay.accept(Void())
                    }
                    .disposed(by: disposeBag)
                
                return button
            }
            
            contentsButtons.forEach { storeImageView.addSubview($0) }
            
            storeImageView.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(data.photosUrl.count)
            }
            
            for (index, view) in contentsButtons.enumerated() {
                view.snp.makeConstraints {
                    $0.top.bottom.equalToSuperview()
                    $0.width.equalTo(scrollView.snp.width)
                    if index == 0 {
                        $0.leading.equalToSuperview()
                    } else {
                        $0.leading.equalTo(contentsButtons[index - 1].snp.trailing)
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
