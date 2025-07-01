//
//  SummaryReactor.swift
//  EatsOkay
//
//  Created by 허성필 on 7/1/25.
//

import Foundation
import ReactorKit
import RxSwift

class SummaryReactor: Reactor {
    var initialState: State
    
    var disposeBag = DisposeBag()
    
    init(storeInfo: StoreInfo) {
        self.initialState = State(storeInfo: storeInfo)
    }
    
    enum Action {
        case backButtonTapped // 뒤로가기 버튼 클릭 시
    }
    
    enum Mutation {
       case shouldPop(Bool)
    }
    
    struct State {
        var storeInfo: StoreInfo
        var shouldPop: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.shouldPop(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .shouldPop(let flag):
            newState.shouldPop = flag
        }
        return newState
    }
}
