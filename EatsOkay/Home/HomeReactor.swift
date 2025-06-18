//
//  HomeReactor.swift
//  EatsOkay
//
//  Created by Lee on 6/13/25.
//

import ReactorKit
import RxSwift

class HomeReactor: Reactor {
    var initialState: State

    init() {
        self.initialState = State(
            currentLocation: "서울 강남구",
            totalData: []
        )
    }

    enum Action {
        case viewWillAppear
        case viewDidLoad
        case locationBtnTapped
        case categoryBtnTapped(Category)
        case tableViewItemTapped(SectionData)
    }

    enum Mutation {
        case loadCurrentLocation(String)
        case setCardSection([HomeSectionOfCellModel])
        case initialData([HomeSectionOfCellModel])
        case requestLocationView
        case pushDetailView(data: SectionData)
    }

    struct State {
        var currentLocation: String
        var cardSectionData: [HomeSectionOfCellModel] = []
        fileprivate var totalData: [HomeSectionOfCellModel]
        @Pulse var pushLocationView: Void?
        @Pulse var pushDetailViewWithData: SectionData?
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            guard let location = UserDeafaultsManager.shared.readLocation() else {
                return .empty()
            }
            return .just(.loadCurrentLocation(location.address))
        case .viewDidLoad:
            let totalData = SituationDataManager().loadTotalShuffledData()

            let sectionModel = totalData
                .map { sectionData in
                    HomeSectionOfCellModel(
                        section: .cardSection,
                        items: [.cardSection(sectionData)],
                        title: sectionData.title
                    )
            }
            return .just(.initialData(sectionModel))
        case .locationBtnTapped:
            return .just(.requestLocationView)
        case .categoryBtnTapped(let category):
            let totalData: [HomeSectionOfCellModel]
            if category == .all {
                totalData = currentState.totalData
                return .just(.setCardSection(totalData))
            } else {
                totalData = currentState.totalData.filter { sectionModel in
                    guard case let .cardSection(data) = sectionModel.items.first else {
                        return false
                    }
                    return data.category == category
                }
                return .just(.setCardSection(totalData))
            }
        case .tableViewItemTapped(let data):
            return .just(.pushDetailView(data: data))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadCurrentLocation(let location):
            newState.currentLocation = location
        case .setCardSection(let sectionData):
            newState.cardSectionData = sectionData
        case .initialData(let totalData):
            newState.totalData = totalData
        case .requestLocationView:
            newState.pushLocationView = Void()
        case .pushDetailView(let data):
            newState.pushDetailViewWithData = data
        }
        return newState
    }
}
