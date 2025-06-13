//
//  DetailReactor.swift
//  EatsOkay
//
//  Created by 허성필 on 6/12/25.
//

import Foundation
import ReactorKit
import RxSwift

class DetailReactor: Reactor {
    var initialState: State
    var seletedKeywords: [String] // home에서 전달받는 검색 키워드
    
    init(seletedKeywords: [String]) {
        self.seletedKeywords = seletedKeywords
        self.initialState = State()
    }
    
    enum Action {
        case viewDidLoad // 뷰가 DidLoad 되었을 때
        case tableViewItemTapped // 테이블 뷰 셀을 클릭했을 때
        case sortButtonTapped // 정렬 버튼을 클릭했을 때
        case webViewDidDismiss // 웹뷰가 닫혔을 때
    }
    
    enum Mutation {
        case setStore([StoreSection])
        case presentWebView // 모달
        case sortingData // 데이터 정렬
        case dismissWebView // 웹뷰가 닫혔을 때
    }
    
    struct State {
        var storeInfo = [StoreSection]()
        var shouldPresentWebView: Bool = false // 초기 웹뷰 여부 false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            // 네트워크 통신 하고
            let StoreInfo = [
                StoreSection(items: [StoreInfo(
                    displayName: "장충동 족발", primaryTypeDisplayName: "한식",
                    formattedAddress: "서울시 강남구 테헤란로 123",
                    latitude: 37.498,
                    longitude: 127.027,
                    rating: 4.5,
                    googleMapsURI: "maps://store1",
                    userRatingCount: 120,
                    photosNames: ["store1"]
                ),StoreInfo(
                    displayName: "홍콩반점", primaryTypeDisplayName: "중식",
                    formattedAddress: "서울시 영등포구 테헤란로 123",
                    latitude: 37.498,
                    longitude: 127.027,
                    rating: 4.7,
                    googleMapsURI: "maps://store1",
                    userRatingCount: 14,
                    photosNames: ["store1"]
                ),StoreInfo(
                    displayName: "스시로", primaryTypeDisplayName: "일식",
                    formattedAddress: "서울시 서초구 테헤란로 123",
                    latitude: 37.498,
                    longitude: 127.027,
                    rating: 4.9,
                    googleMapsURI: "maps://store1",
                    userRatingCount: 1245,
                    photosNames: ["store1"]
                )
                ])
            ]
            return Observable.just(.setStore(StoreInfo)) // 데이터 받아서 넣기
        case .tableViewItemTapped:
            return Observable.just(.presentWebView) // 웹뷰 띄우기
        case .sortButtonTapped:
            return Observable.just(.sortingData) // storeInfo 정렬
        case .webViewDidDismiss:
            return Observable.just(.dismissWebView) // viewDidmiss
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setStore(let storeInfo):
            newState.storeInfo = storeInfo
        case .presentWebView:
            newState.shouldPresentWebView = true
        case .sortingData:
            break
        case .dismissWebView:
            newState.shouldPresentWebView = false
        }
        return newState
    }
}
