//
//  SummaryViewController.swift
//  EatsOkay
//
//  Created by 허성필 on 6/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit
import SafariServices
import RxDataSources

class SummaryViewController: UIViewController {
    
    typealias Reactor = SummaryReactor
    var reactor: SummaryReactor
    
    var disposeBag = DisposeBag()
    
    init(reactor: SummaryReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let data = [1]
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        collectionView.register(SectionOneViewCell.self, forCellWithReuseIdentifier: SectionOneViewCell.identifier)
        collectionView.register(SectionTwoViewCell.self, forCellWithReuseIdentifier: SectionTwoViewCell.identifier)
        collectionView.register(SectionThreeViewCell.self, forCellWithReuseIdentifier: SectionThreeViewCell.identifier)
        collectionView.register(SectionFourViewCell.self, forCellWithReuseIdentifier: SectionFourViewCell.identifier)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.register(CustomHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.identifier)
        
        return collectionView
    }()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "chevronLeft"),
            style: .plain,
            target: nil,
            action: nil
        )
        return button
    }()
    
    private let webViewButton: UIButton = {
        let button = CustomButton(title: " 웹에서 보기")
        button.setImage(UIImage(named: "WebIcon"), for: .normal)
        button.setImage(UIImage(named: "WebIcon"), for: .highlighted)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SummarySectionModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupNaviBar()
        
        bind(reactor: reactor)
    }
    
    private lazy var dataSource = self.makeDataSource()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupNaviBar() {
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .customColor(hexCode: .neutral950)
        
        // 네비게이션 바 타이틀 색상, 폰트 설정
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.customColor(hexCode: .neutral950),
            .font: UIFont.customFontForHeader(weight: .w800)
        ]
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                // 첫번째 섹션 레이아웃 만들기
                return self.createOneSection()
            case 1:
                // 두번째 섹션 레이아웃 만들기
                return self.createTwoSection()
            case 2:
                // 세번째 섹션 레이아웃 만들기
                return self.createThreeSection()
            case 3:
                // 네번째 섹션 레이아웃 만들기
                return self.createFourSection()
            default:
                return self.createDefaultSectionLayout()
            }
        }
        return layout
    }
    
    // 첫번째 섹션 - 성필
    private func createOneSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.32948))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    
    // 두번째 섹션 - 성필
    private func createTwoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3196))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        return section
        
    }
    
    // 세번째 섹션 - 혜민
    private func createThreeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1943))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let items = reactor.currentState.section[2].items
        
        // 섹션이 비어있지 않다면 헤더 추가
        if !items.isEmpty {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(65))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    
    // 네번째 섹션 - 기태
    private func createFourSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.46952))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // 기본 섹션 레이아웃 만들기
    private func createDefaultSectionLayout() -> NSCollectionLayoutSection {
        // 1. item Size 만들기
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        
        // 2. item을 만들기
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 3.Group Size 만들기
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        
        // 4.group 만들기
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // 5.section 만들기
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func setupView() {
        view.backgroundColor = .customColor(hexCode: .bgColor)
        
        [webViewButton, collectionView].forEach{
            view.addSubview($0)
        }
        
        // button autoLayout 설정
        webViewButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        // collectionView autoLayout 설정
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(webViewButton.snp.top).offset(-10)
        }
        
    }
    
}

extension SummaryViewController {
    func bind(reactor: SummaryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SummaryReactor) {
        
        // viewDidLoad 시점시
        reactor.action.onNext(.viewDidLoad)
        
        // 뒤로가기 버튼 클릭 시
        backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // webViewButton 클릭 시
        webViewButton.rx.tap
            .map { Reactor.Action.webViewButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SummaryReactor) {
        
        // 컬렉션 뷰 RxDataSource 바인딩
        reactor.state
            .map { $0.section }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 네비게이션 바 타이틀 바인딩
        reactor.state
            .map { $0.storeInfo.displayName }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, title in
                owner.title = title
            }
            .disposed(by: disposeBag)
        
        // back Button 클릭 시
        reactor.state
            .map { $0.shouldPop }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // webViewButton 클릭 시
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
    }
    
}

extension SummaryViewController {
    private func makeDataSource() -> DataSource {
        return DataSource(configureCell: { dataSource, collectionView, indexPath, item in

            switch item {
            case .summaryImageCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionOneViewCell.identifier, for: indexPath) as? SectionOneViewCell else { return .init()}
                cell.update(with: item)
                return cell
            case .summaryInfoCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionTwoViewCell.identifier, for: indexPath) as? SectionTwoViewCell else { return .init()}
                cell.update(with: item)
                return cell
            case .summaryFeaturesCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionThreeViewCell.identifier, for: indexPath) as? SectionThreeViewCell else { return .init()}
                cell.update(with: item)
                return cell
            case .summaryMapCell:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionFourViewCell.identifier, for: indexPath) as? SectionFourViewCell else { return .init()}
                let image = UIImage(resource: .company2)
                cell.update(image: image)
                cell.update(text: "")
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let section = dataSource.sectionModels[indexPath.section]
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderView.identifier, for: indexPath) as? CustomHeaderView else { return .init() }
                switch indexPath.section {
                case 2:
                    header.configure(with: section.section.title)
                case 3:
                    header.configure(with: section.section.title)
                default: break
                }
                return header
            }
            return UICollectionReusableView()
        }
        )
    }
}
    
// 모달을 완료 버튼으로 dismiss 했을 때 체크
extension SummaryViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        reactor.action.onNext(.webViewDidDismiss)
    }
}

// 모달을 드래그로 dismiss 했을 때 체크
extension SummaryViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        reactor.action.onNext(.webViewDidDismiss)
    }
}
