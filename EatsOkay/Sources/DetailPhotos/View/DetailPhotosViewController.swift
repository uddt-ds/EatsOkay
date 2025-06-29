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

    private let label = UILabel()

    // TODO : 임시 섹션(삭제 예정, 데이터 바인딩 후에는 필요없는 Relay)
    private let sections = BehaviorRelay<[DetailPhotosSectionOfCellModel]>(value: [])

    private var disposeBag = DisposeBag()
    private lazy var dataSource = makeDataSource()

    // TODO : DetailVC로부터 데이터 바인딩 필요
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        setMokeData()
        bindCollectionView()
        setNavigation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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

    private func setNavigation() {
        self.title = "가게 라벨"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.customFontForHeader(weight: .w800)
        ]

        // TODO : back버튼 누르면 이전 View로 돌아가게 바인딩 필요
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "closeIcon"),
                                             style: .done,
                                             target: nil,
                                             action: nil)
        backButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = backButtonItem

        /* TODO :
         title에 사진 총 개수, 현재 선택된 사진 바인딩 필요 / 터치 이벤트 삭제 필요
         버튼 외 Label을 얹을지 고민 중
         */
        let rightButtonItem = UIBarButtonItem(title: "1 / 3",
                                              style: .plain,
                                              target: nil,
                                              action: nil)

        rightButtonItem.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.customFontForBody(weight: .w500)
        ], for: .normal)
        navigationItem.rightBarButtonItem = rightButtonItem
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
