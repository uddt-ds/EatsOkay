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
    
    init() {
        self.initialState = State()
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        }
        return newState
    }
}
