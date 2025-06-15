//
//  HomeReactor.swift
//  EatsOkay
//
//  Created by Lee on 6/13/25.
//

import ReactorKit
import RxSwift

/*
 의견 : UserLocation Struct 밖으로 빼야할거 같은데..
 */

class HomeReactor: Reactor {
    var initialState: State

    init(initialLocation: UserDeafaultsManager.UserLocation) {
        self.initialState = State(currentLocation: initialLocation)
    }

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
        case pushDetailView(keyword: [String])
    }

    struct State {
        var currentLocation: UserDeafaultsManager.UserLocation// 로케이션 초기값 필요
        var currentCategory = Category.all
        var cardSectionData: [SectionData] = []
        @Pulse var pushLocationView = false
        @Pulse var pushWithKeyword: [String]? = nil
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let location = currentState.currentLocation
            return .just(.loadCurrentLocation(location))
        case .viewDidLoad:
            let totalData = SituationDataManager().loadTotalShuffledData()
            return .just(.setCardSection(totalData))
        case .locationBtnTapped:
            return .just(.requestLocationView)
        case .categoryBtnTapped(let category):
            let categoryData = SituationDataManager().loadTotalShuffledData().filter { $0.category == category }
            return .just(.setCardSection(categoryData))
        case .tableViewItemTapped(let dataModel):
            return .just(.pushDetailView(keyword: dataModel.keywords))
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
        case .pushDetailView(keyword: let keyword):
            newState.pushWithKeyword = keyword
        }
        return newState
    }
}
