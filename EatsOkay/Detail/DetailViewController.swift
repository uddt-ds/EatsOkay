//
//  DetailViewController.swift
//  EatsOkay
//
//  Created by 허성필 on 6/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class DetailViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    // 리엑터로 빠질 예정 (목데이터)
    var storeInfos: BehaviorRelay<[StoreSection]> = BehaviorRelay(value: [
        StoreSection(items: [StoreInfo(
            displayName: "어슬렁1",
            formattedAddress: "서울시 강남구 테헤란로 123",
            latitude: 37.498,
            longitude: 127.027,
            rating: 4.5,
            googleMapsURI: "maps://store1",
            userRatingCount: 120,
            photosNames: ["store1"]
        ),StoreInfo(
            displayName: "어슬렁2",
            formattedAddress: "서울시 강남구 테헤란로 123",
            latitude: 37.498,
            longitude: 127.027,
            rating: 4.5,
            googleMapsURI: "maps://store1",
            userRatingCount: 120,
            photosNames: ["store1"]
        ),StoreInfo(
            displayName: "어슬렁3",
            formattedAddress: "서울시 강남구 테헤란로 123",
            latitude: 37.498,
            longitude: 127.027,
            rating: 4.5,
            googleMapsURI: "maps://store1",
            userRatingCount: 120,
            photosNames: ["store1"]
        ),
        ])
    ])
    
    private let storeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "5개의 매장"
        label.textColor = .customColor(hexCode: .neutral700)
        label.font = .customFontForSubtitle(weight: .w600)
        return label
    }()
    
    private let sortButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        let font = UIFont.customFontForSubtitle(weight: .w600)
        let title = "별점순"
        let attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
        config.attributedTitle = attributedTitle
        
        config.image = UIImage(named: "ChevronDown")
        config.imagePadding = 2     // 텍스트와 이미지 사이 간격
        config.imagePlacement = .trailing // 텍스트 오른쪽에 이미지
        config.contentInsets = .zero
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .customColor(hexCode: .neutral950)
        
        let updateTitle: (String) -> Void = { newTitle in
            var updatedConfig = button.configuration
            let attributedTitle = AttributedString(newTitle, attributes: AttributeContainer([.font: font]))
            updatedConfig?.attributedTitle = attributedTitle
            button.configuration = updatedConfig
        }
        
        let menuItems = [
            UIAction(title: "별점순", handler: { _ in updateTitle("별점순") }),
            UIAction(title: "거리순", handler: { _ in updateTitle("거리순") }),
            UIAction(title: "리뷰순", handler: { _ in updateTitle("리뷰순") }),
            UIAction(title: "가격순", handler: { _ in updateTitle("가격순") })
        ]
        
        button.menu = UIMenu(title: "", options: .displayInline , children: menuItems)
        button.showsMenuAsPrimaryAction = true
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .customColor(hexCode: .neutral50)
        return view
    }()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 145 // delegate 사용 안하고 셀 높이 설정
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .customColor(hexCode: .bgColor)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindTableView()
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<StoreSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.configureView(with: item)
                return cell
            }
        )
        
        storeInfos
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected // 웹뷰 모달이 될 예정 Action
            .withUnretained(self)
            .bind { vc, indexPath in
                var test = vc.storeInfos.value
                let random = Int.random(in: 1...1000)
                test[0].items.insert(.init(displayName: "애니메이션 테스트 \(random)", formattedAddress: "서울시 강남구 압구정동 \(random)", latitude: 33.44, longitude: 44.55, rating: 4.7, googleMapsURI: "https://afasfs", userRatingCount: random, photosNames: ["https://afasfs"]), at: indexPath.row)
                vc.storeInfos.accept(test)
            }.disposed(by: disposeBag)
    }

    private func configureUI() {
        view.backgroundColor = .customColor(hexCode: .bgColor)
        
        [storeCountLabel, sortButton, separatorView, tableView].forEach {
            view.addSubview($0)
        }
        
        // 매장 카운드
        storeCountLabel.snp.makeConstraints { make in
            // 기기별 safeAreaHeight를 구하기
            let safeAreaHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
            
            // 구한 safeAreaHeight에 비율 0.389를 곱해서 위치 잡기
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(safeAreaHeight * 0.389)
            make.leading.equalToSuperview().offset(20)
        }
        
        // 정렬 버튼
        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(storeCountLabel)
        }
        
        // 구분선
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(storeCountLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        // 테이블 뷰
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
}
