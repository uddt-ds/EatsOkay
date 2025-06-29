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

class DetailPhotosViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
    }

    private func configureUI() {
        [collectionView].forEach { view.addSubview($0) }
        collectionView.isScrollEnabled = false
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

        let sectionDecoration = NSCollectionLayoutDecorationItem.background(elementKind: String(describing: BlackBackgroundView.self))
        section.decorationItems = [sectionDecoration]

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

extension DetailPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: MainPhotosCell.self),
                for: indexPath
            ) as? MainPhotosCell else { return .init() }
            return cell

        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: TotalPhotosCell.self),
                for: indexPath
            ) as? TotalPhotosCell else { return .init() }
            cell.configureImage(imageName: "company1")
            return cell

        default:
            return .init()
        }
    }
}
