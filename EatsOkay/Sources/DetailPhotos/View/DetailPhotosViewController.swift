//
//  DetailPhotosViewController.swift
//  EatsOkay
//
//  Created by Lee on 6/28/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailPhotosViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )

        collectionView.register(MainPhotosCell.self,
                                forCellWithReuseIdentifier: String(describing: MainPhotosCell.self))
        collectionView.register(TotalPhotosCell.self,
                                forCellWithReuseIdentifier: String(describing: TotalPhotosCell.self))

        return collectionView
    }()

    // 임시 Relay
    private let sections = BehaviorRelay<[DetailPhotosSectionOfCellModel]>(value: [])

    private var disposeBag = DisposeBag()
    private lazy var dataSource = makeDataSource()

    // 임시 데이터
    private func setMokeData() {
        let sectionData: [DetailPhotosSectionOfCellModel] = [
            .init(section: .mainPhotosSection, items: [
                .mainPhotosSection(imageName: "company1"),
                .mainPhotosSection(imageName: "company2"),
                .mainPhotosSection(imageName: "company3")
            ]),
            .init(section: .totalPhotosSection, items: [
                .totalPhotosSection(imageName: "company1"),
                .totalPhotosSection(imageName: "company2"),
                .totalPhotosSection(imageName: "company3")
            ])
        ]

        sections.accept(sectionData)
    }

    private func bindCollectionView() {
        sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        setMokeData()
        bindCollectionView()
    }

    private func configureUI() {
        [collectionView].forEach { view.addSubview($0) }
        collectionView.isScrollEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
    }

    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    override func viewDidLayoutSubviews() {
        print(collectionView.contentSize)
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, environment in

            switch sectionIndex {
            case 0:
                return self.createHorizontalMainItemSection()
            case 1:
                return self.createHorizontalSubItemSection()
            default:
                return self.createDefaultSectionLayout()
            }
        }
        
        layout.register(BlackBackgroundView.self,
                        forDecorationViewOfKind: String(describing: BlackBackgroundView.self))

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

        let sectionBgDecoration = NSCollectionLayoutDecorationItem.background(elementKind: String(describing: BlackBackgroundView.self))
        section.decorationItems = [sectionBgDecoration]

        return section
    }

    func createDefaultSectionLayout() -> NSCollectionLayoutSection {
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

extension DetailPhotosViewController {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<DetailPhotosSectionOfCellModel>
    private func makeDataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, item in
            switch item {
            case .mainPhotosSection(let imageName):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: MainPhotosCell.self),
                    for: indexPath
                ) as? MainPhotosCell else { return .init() }
                cell.configureImage(imageName: imageName)
                return cell
            case .totalPhotosSection(let imageName):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: TotalPhotosCell.self),
                    for: indexPath
                ) as? TotalPhotosCell else { return .init() }
                cell.configureImage(imageName: imageName)
                return cell
            }
        }
    }
}
