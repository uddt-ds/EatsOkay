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
import ReactorKit
import SafariServices

class DetailViewController: UIViewController, View {
    typealias Reactor = DetailReactor
    
    var disposeBag = DisposeBag()
    let reactor = DetailReactor(seletedKeywords: ["치킨", "족발"])
    
    private let storeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "5개의 매장"
        label.textColor = .customColor(hexCode: .neutral700)
        label.font = .customFontForSubtitle(weight: .w600)
        return label
    }()
    
    lazy var sortButton: UIButton = {
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
            UIAction(title: "별점순", handler: { _ in
                self.reactor.action.onNext(.sortButtonTapped(sortType: .rating))
                updateTitle("별점순") }),
            UIAction(title: "거리순", handler: { _ in
                self.reactor.action.onNext(.sortButtonTapped(sortType: .distance))
                updateTitle("거리순") }),
            UIAction(title: "리뷰순", handler: { _ in
                self.reactor.action.onNext(.sortButtonTapped(sortType: .reviewCount))
                updateTitle("리뷰순") })
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
    
    // MARK: - viewDidLoad -
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(reactor: reactor)
    }
    
    // MARK: - Reactor bind -
    func bind(reactor: DetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailReactor) {
        // viewDidLoad 될 때 Action
        reactor.action.onNext(.viewDidLoad) // 주로 just 사용
        
        // 테이블 뷰 cell 클릭시 Action
        tableView.rx.itemSelected
            .map { indexPath in Reactor.Action.tableViewItemTapped(IndexPath: indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindState(reactor: DetailReactor) {
        
        // TableView rxDataSource
        let dataSource = RxTableViewSectionedAnimatedDataSource<StoreSection>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.configureView(with: item)
                return cell
            }
        )
        
        // 테이블 뷰 State 바인딩
        reactor.state
            .map { $0.storeInfo }
            .asDriver(onErrorDriveWith: .empty())
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // tableView cell 클릭 시 WebView 띄우기
        reactor.state
            .map { $0.shouldPresentWebView }
            .distinctUntilChanged()
            .filter { $0 }
            .withLatestFrom(reactor.state.map { $0.webViewUrl })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] urlString in
                guard let url = URL(string: urlString) else { return }
                let safariVC = SFSafariViewController(url: url)
                safariVC.modalPresentationStyle = .popover
                safariVC.delegate = self // 모달 닫기 delegate
                safariVC.presentationController?.delegate = self // 모달 드래그 delegate
                self?.present(safariVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // 매장 개수 Label에 StoreInfo 매장 개수 바인딩
        reactor.state
            .map { $0.storeInfo.flatMap { $0.items }.count }
            .distinctUntilChanged() // 같은 값은 출력하지 않음 - 매장 수가 변경될 때만 표시
            .map { "\($0)개의 매장"}
            .asDriver(onErrorJustReturn: "0개의 매장") // 에러시 출력
            .drive(storeCountLabel.rx.text)
            .disposed(by: disposeBag)

    }

    // MARK: - UI 구현 부분 -
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

// 모달을 완료 버튼으로 dismiss 했을 때 체크
extension DetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        reactor.action.onNext(.webViewDidDismiss)
    }
}

// 모달을 드래그로 dismiss 했을 때 체크
extension DetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        reactor.action.onNext(.webViewDidDismiss)
    }
}
