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
        case webViewButtonTapped
        case webViewDidDismiss
    }
    
    enum Mutation {
        case shouldPop(Bool)
        case setWebViewUri(String)
        case dismissWebView
    }
    
    struct State {
        var storeInfo: StoreInfo
        var shouldPop: Bool = false
        var webViewUrl: String? = nil
        var shouldPresentWebView: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.shouldPop(true))
        case .webViewButtonTapped:
            let storeInfo = currentState.storeInfo
            let uri = storeInfo.googleMapsUri
            return Observable.just(.setWebViewUri(uri))
        case .webViewDidDismiss:
            return Observable.just(.dismissWebView)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .shouldPop(let flag):
            newState.shouldPop = flag
        case .setWebViewUri(let uri):
            newState.webViewUrl = uri
            newState.shouldPresentWebView = true
        case .dismissWebView:
            newState.shouldPresentWebView = false
        }
        return newState
    }
}
