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

    init(initialLocation: UserDeafaultsManager.UserLocation) {
        self.initialState = State(currentLocation: initialLocation)
    }

    private let dataManager = SituationDataManager()
    private lazy var totalData = dataManager.loadTotalShuffledData()

    enum Action {
        case viewWillAppear
        case viewDidLoad
        case locationBtnTapped
        case categoryBtnTapped(Category)
        case tableViewItemTapped(SectionData)
    }

    enum Mutation {
        case loadCurrentLocation(UserDeafaultsManager.UserLocation)
        case setCardSection([SectionData])
        case requestLocationView
        case pushDetailView(data: SectionData)
    }

    struct State {
        var currentLocation: UserDeafaultsManager.UserLocation// 로케이션 초기값 필요
        var cardSectionData: [SectionData] = []
        @Pulse var pushLocationView: Bool? = nil
        @Pulse var pushDetailViewWithData: SectionData? = nil
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let location = currentState.currentLocation
            return .just(.loadCurrentLocation(location))
        case .viewDidLoad:
            return .just(.setCardSection(totalData))
        case .locationBtnTapped:
            return .just(.requestLocationView)
        case .categoryBtnTapped(let category):
            let categoryData =
            category == .all ? totalData : totalData.filter { $0.category == category }
            return .just(.setCardSection(categoryData))
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
        case .requestLocationView:
            newState.pushLocationView = true
        case .pushDetailView(data: let data):
            newState.pushDetailViewWithData = data
        }
        return newState
    }
}
