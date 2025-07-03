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
        self.initialState = State(storeInfo: storeInfo, setSections: [])
    }
    
    enum Action {
        case viewDidLoad // viewDidLoad 시
        case backButtonTapped // 뒤로가기 버튼 클릭 시
        case webViewButtonTapped
        case webViewDidDismiss
        case imagePageChanged(Int)
        case callButtonTapped
    }
    
    enum Mutation {
        case setSections([SummarySectionModel])
        case shouldPop(Bool)
        case setWebViewUri(String)
        case dismissWebView
        case setImagePage(Int)
        case setNationalNumber(String?)
    }
    
    struct State {
        var storeInfo: StoreInfo
        var setSections: [SummarySectionModel]
        var imagesUri: [String] = []
        var shouldPop: Bool = false
        var webViewUrl: String? = nil
        var shouldPresentWebView: Bool = false
        var currentImagePage: Int = 1
        @Pulse var nationalNumber: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let storeInfo = currentState.storeInfo
            let firstImageUrl = storeInfo.photosNames
            
            let photos = storeInfo.photos ?? []
            
            let secondImageName = photos.count > 1 ? photos[1].name : "DefaultImage"
            let thirdImageName  = photos.count > 2 ? photos[2].name : "DefaultImage"
            
            let secondImage: Single<String> = secondImageName == "DefaultImage" ? .just("DefaultImage")
            : NetworkManager.shared.fetchImage(mediaName: secondImageName).map { $0.photoUri }
            
            let thirdImage: Single<String> = thirdImageName == "DefaultImage" ? .just("DefaultImage")
            : NetworkManager.shared.fetchImage(mediaName: thirdImageName).map { $0.photoUri }
            
            return Single.zip(secondImage, thirdImage)
                .map { secondImageUrl, thirdImageUrl in
                    // 섹션 1
                    let photoUri: [SummarySectionModel.CellModel] = [
                        .summaryImageCell(
                            .init(photosUrl: [firstImageUrl, secondImageUrl, thirdImageUrl])
                        )
                    ]
                    let imageSection = SummarySectionModel(section: .summaryImage, items: photoUri)
                    
                    // 섹션 2
                    let infoItems: [SummarySectionModel.CellModel] = [
                        .summaryInfoCell(.init(
                            storeName: storeInfo.displayName,
                            storeAddress: storeInfo.formattedAddress,
                            storeType: storeInfo.primaryTypeDisplayName,
                            rate: "\(storeInfo.rating)",
                            reviewCount: "리뷰 \(storeInfo.userRatingCount)개",
                            isOpen: storeInfo.currentOpeningHours.openNow,
                            openInfo: OpeningHours.getTodayClosingOrTomorrowOpening(openingHours: storeInfo.currentOpeningHours),
                            storePhoneNumber: storeInfo.nationalPhoneNumber))
                    ]
                    let infoSection = SummarySectionModel(section: .summaryInfo, items: infoItems)
                    
                    // 섹션 3
                    let hasFeatureInfo = (storeInfo.goodForGroups ?? false) ||
                    (storeInfo.takeout ?? false) ||
                    (storeInfo.reservable ?? false) ||
                    (storeInfo.parkingOptions?.freeParkingLot ?? false) ||
                    (storeInfo.parkingOptions?.paidParkingLot ?? false) ||
                    (storeInfo.parkingOptions?.freeStreetParking ?? false) ||
                    (storeInfo.parkingOptions?.paidStreetParking ?? false) ||
                    (storeInfo.parkingOptions?.valetParking ?? false) ||
                    (storeInfo.parkingOptions?.freeGarageParking ?? false) ||
                    (storeInfo.parkingOptions?.paidGarageParking ?? false)
                    
                    // 단체모임/포장/예약/주차 정보가 모두 false 또는 nil일 경우 빈 배열 반환
                    let featuresItems: [SummarySectionModel.CellModel] = hasFeatureInfo ? [
                        .summaryFeaturesCell(
                            .init(
                                goodForGroups: storeInfo.goodForGroups,
                                takeout: storeInfo.takeout,
                                reservable: storeInfo.reservable,
                                parkingOptions: storeInfo.parkingOptions
                            )
                        )
                    ] : []
                    
                    let featuresSection = SummarySectionModel(section: .summaryFeatures, items: featuresItems)
                    
                    // 섹션 4
                    let centerLat = storeInfo.latitude
                    let centerLon = storeInfo.longitude
                    let mapImageUrl = NetworkManager.shared.fetchStaticURL(center: "\(centerLat),\(centerLon)")
                    let mapItems: [SummarySectionModel.CellModel] = [
                        .summaryMapCell(
                            .init(imageUrl: mapImageUrl ?? "", address: storeInfo.formattedAddress)
                        )
                    ]
                    let mapSection = SummarySectionModel(section: .summaryMap, items: mapItems)
                    
                    // 4개의 섹션 데이터들을 하나로 병합
                    let dataSource: [SummarySectionModel] = [
                        imageSection,
                        infoSection,
                        featuresSection,
                        mapSection
                    ]
                    
                    return Mutation.setSections(dataSource)
                }
                .asObservable()
        case .backButtonTapped:
            return .just(.shouldPop(true))
        case .webViewButtonTapped:
            let storeInfo = currentState.storeInfo
            let uri = storeInfo.googleMapsUri
            return Observable.just(.setWebViewUri(uri))
        case .webViewDidDismiss:
            return Observable.just(.dismissWebView)
        case .imagePageChanged(let page):
            return Observable.just(.setImagePage(page))
        case .callButtonTapped:
            let nationalNumber = currentState.storeInfo.nationalPhoneNumber
            return Observable.just(.setNationalNumber(nationalNumber))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSections(let dataSource):
            newState.setSections = dataSource
        case .shouldPop(let flag):
            newState.shouldPop = flag
        case .setWebViewUri(let uri):
            newState.webViewUrl = uri
            newState.shouldPresentWebView = true
        case .dismissWebView:
            newState.shouldPresentWebView = false
        case .setImagePage(let page):
            newState.currentImagePage = page
        case .setNationalNumber(let nationalNumber):
            newState.nationalNumber = nationalNumber
        }
        return newState
    }
}
