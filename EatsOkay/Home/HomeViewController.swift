//
//  HomeViewController.swift
//  EatsOkay
//
//  Created by Lee on 6/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import RxDataSources

final class HomeViewController: UIViewController {

    let situationDataManager = SituationDataManager()

    let locationHeaderView = LocationHeaderView()
    let categoryButtonView = CategoryBtnView()
    let tableView = UITableView()

    let disposeBag = DisposeBag()

    typealias DataSource = RxTableViewSectionedAnimatedDataSource<HomeSectionOfCellModel>

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
        bind()

        tableView.register(CardSectionsCell.self,
                           forCellReuseIdentifier: String(describing: CardSectionsCell.self))
    }

    private lazy var dataSource = self.makeDataSource()

    private func configureUI() {
        view.backgroundColor = .white
        
        [locationHeaderView, categoryButtonView, tableView]
            .forEach { view.addSubview($0) }

        tableView.rowHeight = 228
        tableView.separatorStyle = .none
    }

    private func setConstraints() {

        locationHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(92)
        }

        categoryButtonView.snp.makeConstraints { make in
            make.top.equalTo(locationHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(72)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryButtonView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bind() {
        categoryButtonView.selectedIndex
            .distinctUntilChanged()
            .withUnretained(self)
            .map { vc, selectedIndex -> [HomeSectionOfCellModel] in
                switch selectedIndex {
                case 0:
                    let totalData = vc.situationDataManager.loadTotalShuffledData()
                    return [HomeSectionOfCellModel(
                        section: .cardSection,
                        items: totalData.map { .cardSection($0) }
                    )]
                case 1:
                    let dailyData =
                    vc.situationDataManager.loadCategoryData(category: .daily).sections
                    return [HomeSectionOfCellModel(
                        section: .cardSection,
                        items: dailyData.map { .cardSection($0) }
                    )]
                case 2:
                    let workoutData = vc.situationDataManager.loadCategoryData(category: .workout).sections
                    return [HomeSectionOfCellModel(
                        section: .cardSection, items: workoutData.map { .cardSection($0) }
                    )]
                case 3:
                    let companyData = vc.situationDataManager.loadCategoryData(category: .company).sections
                    return [HomeSectionOfCellModel(
                        section: .cardSection, items: companyData.map { .cardSection($0)
                        }
                    )]
                case 4:
                    let loveData = vc.situationDataManager.loadCategoryData(category: .love).sections
                    return [HomeSectionOfCellModel(section: .cardSection, items: loveData.map { .cardSection($0) }
                    )]

                case 5:
                    let seasonData =
                    vc.situationDataManager.loadCategoryData(category: .season).sections
                    return [HomeSectionOfCellModel(section: .cardSection, items: seasonData.map{ .cardSection($0) }
                    )]
                default:
                    return [HomeSectionOfCellModel(section: .cardSection, items: .init())]
                }
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(HomeSectionOfCellModel.CellModel.self)
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive { vc, selectedModel in
                switch selectedModel {
                case .cardSection(let sectionData):
                    print("선택된 키워드 : \(sectionData.keywords)")
                }
            }.disposed(by: disposeBag)

        locationHeaderView.rx.editIconButtonTap
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive { vc, _ in
                print("버튼이 눌렸습니다")
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func makeDataSource() -> DataSource {
        return DataSource(configureCell: {
            dataSource, tableView, indexPath, item in

            switch item {
            case .cardSection(let section):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CardSectionsCell.self), for: indexPath) as? CardSectionsCell else {
                    return .init()
                }
                cell.configureCell(data: section)
                return cell
            }
        })
    }
}
