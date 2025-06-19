//
//  OnBoardingReactor.swift
//  EatsOkay
//
//  Created by 김기태 on 6/9/25.
//

import Foundation
import ReactorKit

final class OnboardingReactor: Reactor {
    
    enum Action {
        case scrollAction(Int)
        case startButtonTapped
    }

    enum Mutation {
        case setCurrentPage(Int)
        case completeOnboarding
    }

    struct State {
        var currentPage: Int = 0
        var isCompleted: Bool?

        let pages: [OnboardingPageModel] = [
            .init(title: "맞춤 큐레이션", description: "상황별 딱 맞는\n다양한 외식 큐레이션 제공!", imageName: "onBoarding1"),
            .init(title: "위치 기반 추천", description: "내 주변 맛집을\n지도와 함께 확인하세요!", imageName: "onBoarding2"),
            .init(title: "필터 기능", description: "별점, 거리, 리뷰까지\n원하는 조건으로 비교하세요!", imageName: "onBoarding3")
        ]

        var currentPageModel: OnboardingPageModel {
            return pages[currentPage]
            
        }
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {

        case .scrollAction(let page):
            return .just(.setCurrentPage(page))
            
        case .startButtonTapped:
            UserDefaultsManager.shared.saveStatus()
            return .just(.completeOnboarding)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        switch mutation {
        case .setCurrentPage(let page):
            newState.currentPage = page
        case .completeOnboarding:
            newState.isCompleted = true
        }
        return newState
    }
}

