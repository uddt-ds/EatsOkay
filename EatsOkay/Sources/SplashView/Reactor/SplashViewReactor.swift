//
//  SplashViewReactor.swift
//  EatsOkay
//
//  Created by 김기태 on 6/13/25.
//

import Foundation
import ReactorKit

final class SplashViewReactor: Reactor {
    var initialState: State = .init()
    
    enum Action {
        case initialCheck
    }
    
    enum Mutation {
        case checkCompletion(Bool)
    }
    
    struct State {
        var isCompleted: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialCheck:
            let isCompleted = UserDefaultsManager.shared.readStatus()
            return .just(.checkCompletion(isCompleted))
                .delay(.seconds(3), scheduler: MainScheduler.instance)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .checkCompletion(let bool):
            newState.isCompleted = bool
        }
        return newState
    }
}
