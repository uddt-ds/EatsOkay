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
        self.initialState = State(currentLocation: "서울 강남구")
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
        case loadCurrentLocation(String)
        case setCardSection([SectionData])
        case requestLocationView
        case pushDetailView(data: SectionData)
    }

    struct State {
        var currentLocation: String
        var cardSectionData: [SectionData] = []
        @Pulse var pushLocationView: Void?
        @Pulse var pushDetailViewWithData: SectionData?
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            guard let location = UserDeafaultsManager.shared.readLocation()
            else { return .empty() }
            return .just(.loadCurrentLocation(location.address))
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
            newState.pushLocationView = Void()
        case .pushDetailView(let data):
            newState.pushDetailViewWithData = data
        }
        return newState
    }
}
