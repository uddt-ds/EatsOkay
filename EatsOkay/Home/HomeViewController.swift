//
//  HomeViewController.swift
//  EatsOkay
//
//  Created by Lee on 6/16/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit
import RxDataSources
import ReactorKit

final class HomeViewController: UIViewController, View {
    typealias Reactor = HomeReactor

    private let reactor: HomeReactor
    var disposeBag = DisposeBag()

    init(reactor: HomeReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let locationHeaderView = LocationHeaderView()
    private let categoryBtnShadowView = UIView()
    private let categoryButtonView = CategoryBtnView()
    private let tableView = UITableView()


    typealias DataSource = RxTableViewSectionedAnimatedDataSource<HomeSectionOfCellModel>

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()

        tableView.register(CardSectionsCell.self,
                           forCellReuseIdentifier: String(describing: CardSectionsCell.self))

        bind(reactor: reactor)
    }

    private lazy var dataSource = self.makeDataSource()

    private func configureUI() {
        view.backgroundColor = .white

        [locationHeaderView, tableView, categoryButtonView]
            .forEach { view.addSubview($0) }

        tableView.rowHeight = 260
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

    func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindAction(reactor: HomeReactor) {
        self.rx.viewWillAppear
            .map { _ in
                Reactor.Action.viewWillAppear
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.just(Void())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        locationHeaderView.rx.locationEditButton
            .map {
                Reactor.Action.locationBtnTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        categoryButtonView.selectedIndex
            .distinctUntilChanged()
            .compactMap { index in
                Category.allCases[index]
            }
            .map {
                Reactor.Action.categoryBtnTapped($0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(HomeSectionOfCellModel.CellModel.self)
            .map { model -> HomeReactor.Action in
                switch model {
                case .cardSection(let data):
                    return .tableViewItemTapped(data)
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindState(reactor: HomeReactor) {
        reactor.state
            .map { $0.currentLocation }
            .distinctUntilChanged()
            .bind(to: locationHeaderView.currentLocationLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.cardSectionData }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        reactor.pulse(\.$pushLocationView)
            .compactMap { $0 }
            .bind(onNext: {
                print("다음 뷰 push")
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$pushDetailViewWithData)
            .compactMap { $0 }
            .bind(onNext: {
                print("다음 뷰 push, data: \($0.keywords), \($0.title)")
            })
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
