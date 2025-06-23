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

        let width = UIScreen.main.bounds.width
        let height: CGFloat = 4
        let cgRect = CGRect(x: 0, y: 0, width: width, height: height)

        categoryBtnShadowView.layer.shadowPath = UIBezierPath(
            roundedRect: cgRect,
            cornerRadius: 0
        ).cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let locationHeaderView = LocationHeaderView()
    private let categoryButtonView = CategoryBtnView()
    private let tableView = UITableView()

    private lazy var categoryBtnShadowView: UIView = {
        let shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.customColor(hexCode: .neutral950).cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 20
        shadowView.layer.masksToBounds = false
        return shadowView
    }()


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

        [locationHeaderView, tableView, categoryButtonView, categoryBtnShadowView]
            .forEach { view.addSubview($0) }

        tableView.rowHeight = 260
        tableView.separatorStyle = .none

        view.bringSubviewToFront(categoryButtonView)
    }

    private func setConstraints() {
        locationHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(92)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(categoryButtonView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        categoryButtonView.snp.makeConstraints { make in
            make.top.equalTo(locationHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(72)
        }

        categoryBtnShadowView.snp.makeConstraints { make in
            make.top.equalTo(categoryButtonView.snp.bottom).offset(-4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
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
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                let reactor = LocationSelectReactor()
                let locationVC = LocationSelectView(reactor: reactor)
                vc.navigationController?.setViewControllers([locationVC], animated: true)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$pushDetailViewWithData)
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { vc, data in
                let reactor = DetailReactor(sectionData: data)
                let detailVC = DetailViewController(reactor: reactor)
                vc.navigationController?.pushViewController(detailVC, animated: true)
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
