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
                  description: "당신에게 꼭 맞는 콘텐츠만 골라드려요.",
                  imageName: "Image"),
            .init(title: "위치 기반 추천",
                  description: "지금 있는 곳에 딱 맞는 정보를 알려드려요.",
                  imageName: "Image"),
            .init(title: "필터 기능",
                  description: "원하는 조건으로 정확히 찾아보세요.",
                  imageName: "Image")
        ]

        var currentPageModel: OnboardingPageModel {
            let index = max(0, min(currentPage, pages.count - 1))
            return pages[index]
        }

        var currentButtonTitle: String {
            currentPage == pages.count - 1 ? "시작하기" : "다음"
        }
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            return hasSeenOnboarding ? .just(.completeOnboarding) : .empty()

        case .nextTapped:
            let nextPage = currentState.currentPage + 1
            if nextPage >= currentState.pages.count {
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                return .just(.completeOnboarding)
            } else {
                return .just(.setCurrentPage(nextPage))
            }
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
