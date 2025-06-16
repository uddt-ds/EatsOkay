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
        case viewDidLoad
        case scrollAction(Int)
        case nextTapped
    }

    enum Mutation {
        case setCurrentPage(Int)
        case completeOnboarding
    }

    struct State {
        var currentPage: Int = 0
        var isCompleted: Bool = false

        let pages: [OnboardingPageModel] = [
            .init(title: "맞춤 큐레이션",
                  description: "상황별 딱 맞는\n다양한 외식 큐레이션 제공!",
                  imageName: "onBoarding1"),
            .init(title: "위치 기반 추천",
                  description: "내 주변 맛집을\n지도와 함께 확인하세요!",
                  imageName: "onBoarding2"),
            .init(title: "필터 기능",
                  description: "별점, 거리, 리뷰까지\n원하는 조건으로 비교하세요!",
                  imageName: "onBoarding3")
        ]

        var currentPageModel: OnboardingPageModel {
            let index = max(0, min(currentPage, pages.count - 1))
            return pages[index]
        }

        var currentButtonTitle: String {
            currentPage == pages.count - 1 ? "시작하기" : "다음"
        }
        
        var isNextButtonHidden: Bool {
            currentPage != pages.count - 1
        }
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let hasSeenOnboarding = UserDeafaultsManager.shared.readStatus()
            return hasSeenOnboarding ? .just(.completeOnboarding) : .empty()

        case .nextTapped:
            let nextPage = currentState.currentPage + 1
            if nextPage >= currentState.pages.count {
                UserDeafaultsManager.shared.saveStatus()
                return .just(.completeOnboarding)
            } else {
                return .just(.setCurrentPage(nextPage))
            }
        case .scrollAction(let page):
            return .just(.setCurrentPage(page))
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
