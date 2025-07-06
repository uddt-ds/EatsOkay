//
//  DetailPhotosViewController.swift
//  EatsOkay
//
//  Created by Lee on 6/28/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

final class DetailPhotosViewController: UIViewController, View {
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<DetailPhotosSectionOfCellModel>
    
    var disposeBag = DisposeBag()
    var reactor: DetailPhotosReactor
    private let currentPageSubject = PublishRelay<Int>()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )
        
        return collectionView
    }()
    private let topView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .closeIcon), for: .normal)
        return button
    }()
    
    private let countLabel = UILabel()
    
    private let titleLabel = UILabel()
    
    init(reactor: DetailPhotosReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setCollectionView()
        setConstraints()
        bind(reactor: reactor)
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        
        [
            topView,
            collectionView
        ].forEach { view.addSubview($0) }
        
        [
            backButton,
            titleLabel,
            countLabel
        ].forEach { topView.addSubview($0) }
    }
    
    private func setCollectionView() {
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .black
        collectionView.register(MainPhotosCell.self,
                                forCellWithReuseIdentifier: String(describing: MainPhotosCell.self))
        collectionView.register(TotalPhotosCell.self,
                                forCellWithReuseIdentifier: String(describing: TotalPhotosCell.self))
    }

    private func setConstraints() {
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
            $0.top.equalTo(topView.snp.top)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(topView.snp.center)
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalTo(topView.snp.trailing).inset(19.5)
            $0.centerY.equalTo(topView.snp.centerY)
        }
        
        topView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func bind(reactor: DetailPhotosReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailPhotosReactor) {
        Observable.just(())
            .map { Reactor.Action.initialFetch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        currentPageSubject
            .distinctUntilChanged()
            .map { Reactor.Action.imagePaged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .map { $0.item }
            .map { Reactor.Action.previewTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: DetailPhotosReactor) {
        
        let scrollIndexInfo: Observable<(Int, Int)> = reactor.state
            .map { $0.scrollIndex }
            .distinctUntilChanged { $0 == $1 }
        
        scrollIndexInfo
            .map { (index, total) -> NSMutableAttributedString in
                AttributedStringManager.configureString(
                    text: "\(index + 1) / \(total)",
                    font: .customFontForBody(weight: .w500),
                    color: .bgColor
                )
            }
            .bind(to: countLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$selectedIndex)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, index in
                vc.scrollCollectionView(to: index)
            }
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.storeName }
            .distinctUntilChanged()
            .map { title -> NSMutableAttributedString in
                AttributedStringManager.configureString(
                    text: title,
                    font: .customFontForHeader(weight: .w800),
                    color: .bgColor
                )
            }
            .bind(to: titleLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.collectionViewData }
            .bind(to: collectionView.rx.items(dataSource: makeDataSource()))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$dissmissRequest)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                vc.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func makeDataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, item in
            switch item {
            case .mainPhotosSection(let imageName):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: MainPhotosCell.self),
                    for: indexPath
                ) as? MainPhotosCell else { return .init() }
                cell.configureImage(uriString: imageName)
                return cell
            case .totalPhotosSection(let imageName, let isHighlighted):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: TotalPhotosCell.self),
                    for: indexPath
                ) as? TotalPhotosCell else { return .init() }
                cell.configureImage(uriString: imageName, isHighlited: isHighlighted)
                return cell
            }
        }
    }
    
    private func scrollCollectionView(to index: Int) {
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()

            guard self.collectionView.numberOfSections > 0 else { return }
            let itemCount = self.collectionView.numberOfItems(inSection: 0)
            guard index >= 0 && index < itemCount else { return }

            self.collectionView.scrollToItem(
                at: IndexPath(item: index, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self]  sectionIndex, environment in
            switch sectionIndex {
            case 0:
                return self?.createHorizontalMainItemSection()
            case 1:
                return self?.createHorizontalSubItemSection()
            default:
                return self?.createDefaultSectionLayout()
            }
        }
        return layout
    }

    private func createHorizontalMainItemSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.824)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            guard let self = self else { return }
            let currentPage = Int(max(0, round(offset.x / env.container.contentSize.width)))
            self.currentPageSubject.accept(currentPage)
        }
        
        return section
    }

    private func createHorizontalSubItemSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(1/3)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])

        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        section.contentInsets = .init(top: 10, leading: 27.5, bottom: 10, trailing: 27.5)

        return section
    }

    private func createDefaultSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}
