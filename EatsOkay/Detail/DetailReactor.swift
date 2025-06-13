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
    
    var disposeBag = DisposeBag()
    
    init(seletedKeywords: [String]) {
        self.seletedKeywords = seletedKeywords
        self.initialState = State()
    }
    
    enum Action {
        case viewDidLoad // 뷰가 DidLoad 되었을 때
        case tableViewItemTapped(IndexPath: IndexPath) // 테이블 뷰 셀을 클릭했을 때
        case sortButtonTapped // 정렬 버튼을 클릭했을 때
        case webViewDidDismiss // 웹뷰가 닫혔을 때
    }
    
    enum Mutation {
        case setStore([StoreSection])
        case setWebViewUrl(String)
        case sortingData // 데이터 정렬
        case dismissWebView // 웹뷰가 닫혔을 때
    }
    
    struct State {
        var storeInfo = [StoreSection]()
        var shouldPresentWebView: Bool = false // 초기 웹뷰 여부 false
        var webViewUrl: String? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            // TODO: viewDidLoad 될 때 네트워크 통신하기
            // 네트워크 통신 하고 zip으로 병합
            let firstRequest = NetworkManager.shared.fetchPlacesWithCircle(textQuery: "삼겹살", centerLat: 37.5665, centerLon: 126.9780)
                .map { self.convertToStoreInfo(places: $0) }
                .asObservable()
            
            let secondRequest = NetworkManager.shared.fetchPlacesWithCircle(textQuery: "닭발", centerLat: 37.5665, centerLon: 126.9780)
                .map { self.convertToStoreInfo(places: $0) }
                .asObservable()
            
            return Observable.zip(firstRequest, secondRequest)
                .map { firstRequest, secondRequest in
                    let mergeStoreInfo = firstRequest + secondRequest
                    print("첫번째 가게 수 : \(firstRequest.count)")
                    print("두번째 가게 수 : \(secondRequest.count)")
                    print("총 표시 가게 수 : \(mergeStoreInfo.count)")
                    // 별점 순으로 데이터 정렬
                    let sortedMergeStoreInfo = mergeStoreInfo.sorted { $0.rating > $1.rating}
                    
                    return [StoreSection(items: sortedMergeStoreInfo)]
                }
                .map { .setStore($0) }
        case .tableViewItemTapped(let indexPath):
            // TODO: tableView cell 선택 시 웹 뷰 띄우기
            let storeInfo = currentState.storeInfo
            guard indexPath.section < storeInfo.count,
                  indexPath.row < storeInfo[indexPath.section].items.count else {
                return .empty()
            }
            let uri = storeInfo[indexPath.section].items[indexPath.row].googleMapsUri
            return Observable.just(.setWebViewUrl(uri)) // 웹뷰 띄우기
        case .sortButtonTapped:
            // TODO: 정렬 버튼 눌렀을 때 데이터 정렬하기 current State 사용
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
        case .setWebViewUrl(let uri):
            newState.webViewUrl = uri
            newState.shouldPresentWebView = true
        case .sortingData:
            break
        case .dismissWebView:
            newState.shouldPresentWebView = false
        }
        return newState
    }
}

extension DetailReactor {
    // Google Place Response를 StoreInfo로 변환
    func convertToStoreInfo(places: [GoogleMap.Place]) -> [StoreInfo] {
        return places.compactMap { place -> StoreInfo? in
            guard let displayName = place.displayName?.text,
                  let primaryTypeDisplayName = place.primaryTypeDisplayName?.text,
                  let googleMapsUri = place.googleMapsUri,
                  let rating = place.rating,
                  let userRatingCount = place.userRatingCount,
                  let currentOpeningHours = place.currentOpeningHours
            else { return nil }
            
            // photosNames: photos 배열의 첫번째 name 값, 없으면 빈 문자열
            let photosName = place.photos?.first?.name ?? ""
            
            // OpeningHours 변환
            let convertedOpeningHours = convertOpeningHours(currentOpeningHours)
            
            return StoreInfo(
                displayName: displayName, // 가게 이름
                primaryTypeDisplayName: primaryTypeDisplayName, // 가게 종류
                formattedAddress: place.formattedAddress, // 가게 주소
                latitude: place.location.latitude, // 위도
                longitude: place.location.longitude, // 경도
                rating: rating, // 별점
                googleMapsUri: googleMapsUri, // 구글맵 주소
                userRatingCount: userRatingCount, // 리뷰수
                photosNames: photosName, // 리뷰 사진
                currentOpeningHours: convertedOpeningHours // 영업 시간
            )
        }
    }
    
    // googleMap.Place.OpeningHours를 DetailModel의 OpeningHours에 맞춰서 변경
    func convertOpeningHours(_ openingHours: GoogleMap.Place.OpeningHours) -> OpeningHours {
        let periods = openingHours.periods.map { period in
            let open = OpeningHours.Close(
                day: period.open.day,
                hour: period.open.hour,
                minute: period.open.minute,
                date: OpeningHours.DateClass(
                    year: period.open.date.year,
                    month: period.open.date.month,
                    day: period.open.date.day
                )
            )
            let close = OpeningHours.Close(
                day: period.close.day,
                hour: period.close.hour,
                minute: period.close.minute,
                date: OpeningHours.DateClass(
                    year: period.close.date.year,
                    month: period.close.date.month,
                    day: period.close.date.day
                )
            )
            return OpeningHours.Periods(open: open, close: close)
        }
        return OpeningHours(openNow: openingHours.openNow, periods: periods)
    }
}
