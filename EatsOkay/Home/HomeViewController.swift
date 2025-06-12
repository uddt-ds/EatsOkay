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
        let sectionDatas = situationDataManager.loadTotalShuffledData()

        let cellModel = sectionDatas.map { sectionData in
            HomeSectionOfCellModel.CellModel.cardSection(sectionData)
        }

        let sections = [HomeSectionOfCellModel(section: .cardSection, items: cellModel)]

        Observable.just(sections)
            .asDriver(onErrorDriveWith: .empty())
            .drive(tableView.rx.items(dataSource: dataSource))
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
