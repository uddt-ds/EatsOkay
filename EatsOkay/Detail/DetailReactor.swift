import Foundation
import ReactorKit
import RxSwift
import CoreLocation

class DetailReactor: Reactor {
    var initialState: State
    var selectedKeywords: [String] // home에서 전달받는 검색 키워드 // State로 수정 예정
    
    let locationManager = CLLocationManager()
    
    var disposeBag = DisposeBag()
    
    init(selectedKeywords: [String]) {
        self.selectedKeywords = selectedKeywords
        self.initialState = State()
    }
    
    enum Action {
        case viewDidLoad // 뷰가 DidLoad 되었을 때
        case backButtonTapped // 뒤로가기 버튼을 클릭했을 때
        case currentLocationSearchButtonTapped(centerLat: Double, centerLon: Double) // 현 위치에서 검색 버튼 눌렀을 때
        case currentLocationButtonTapped // 현재 위치 버튼 클릭했을 때
        case tableViewItemTapped(IndexPath: IndexPath) // 테이블 뷰 셀을 클릭했을 때
        case sortButtonTapped(sortType: SortType) // 정렬 버튼을 클릭했을 때
        case webViewDidDismiss // 웹뷰가 닫혔을 때
    }
    
    enum SortType: String {
        case rating // 별점순
        case distance // 거리순
        case reviewCount // 리뷰순
    }
    
    enum Mutation {
        case setStore([StoreSection])
        case shouldPop(Bool)
        case setCurrentLocation(lat: Double, lon: Double)
        case showLocationAlert
        case setWebViewUrl(String)
        case sortStore([StoreSection]) // 데이터 정렬
        case dismissWebView // 웹뷰가 닫혔을 때
    }
    
    struct State {
        var storeInfo = [StoreSection]()
        var shouldPop: Bool = false
        // 값이 없을 수 있기 때문에 옵셔널 타입으로 정의
        var currentLatitude: Double?
        var currentLongitude: Double?
        @Pulse var showLocationAlert: Void?
        var shouldPresentWebView: Bool = false // 초기 웹뷰 여부 false
        var webViewUrl: String? = nil
        var sortType: SortType = .rating // 기본값은 별점순
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // TODO: viewDidLoad 될 때 네트워크 통신하기
        case .viewDidLoad:
            // 네트워크 통신 하고 zip으로 병합
            let (centerLat, centerLon) = getCenterLocation()
            
            let firstRequest = NetworkManager.shared.fetchPlacesWithCircle(textQuery: "스시", centerLat: centerLat, centerLon: centerLon)
                .map { self.convertToStoreInfo(places: $0) }
                .asObservable()
            
            let secondRequest = NetworkManager.shared.fetchPlacesWithCircle(textQuery: "스테이크", centerLat: centerLat, centerLon: centerLon)
                .map { self.convertToStoreInfo(places: $0) }
                .asObservable()
            
            // 이미지까지 네트워크 후 킹피셔등 사용해서 섹션 데이터 넘기기
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
        case .backButtonTapped:
            return .just(.shouldPop(true))
        case .currentLocationSearchButtonTapped(let centerLat, let centerLon):
            let requests = selectedKeywords.map {
                NetworkManager.shared.fetchPlacesWithCircle(textQuery: $0, centerLat: centerLat, centerLon: centerLon)
                    .map { self.convertToStoreInfo(places: $0) }
                    .asObservable()
            }
            return Observable.zip(requests)
                .map { $0.flatMap { $0 }}
                .map { stores in
                    let sorted = stores.sorted { $0.rating > $1.rating }
                    return [StoreSection(items: sorted)]
                }
                .map { .setStore($0) }
        case .currentLocationButtonTapped:
            return handleLocationAuthorization()
            // 테이블 뷰 셀 클릭시 웹뷰 띄우기
        case .tableViewItemTapped(let indexPath):
            let storeInfo = currentState.storeInfo
            guard indexPath.section < storeInfo.count,
                  indexPath.row < storeInfo[indexPath.section].items.count else {
                return .empty()
            }
            let uri = storeInfo[indexPath.section].items[indexPath.row].googleMapsUri
            return Observable.just(.setWebViewUrl(uri)) // 웹뷰 띄우기
            // 정렬 부분
        case .sortButtonTapped(let sortType):
            let currentStoreInfo = currentState.storeInfo
            
            // userDefault 사용해서 위치 가져오기
            let (centerLat, centerLon) = getCenterLocation()
            
            let sortedItems = currentStoreInfo.flatMap { $0.items }
                .sorted { item1, item2 in
                    switch sortType {
                    case .rating:
                        return item1.rating > item2.rating
                    case .distance:
                        let distance1 = self.calculateDistance(
                            from: centerLat, lon1: centerLon,
                            to: item1.latitude, lon2: item1.longitude
                        )
                        let distance2 = self.calculateDistance(
                            from: centerLat, lon1: centerLon,
                            to: item2.latitude, lon2: item2.longitude
                        )
                        return distance1 < distance2
                    case .reviewCount:
                        return item1.userRatingCount > item2.userRatingCount
                    }
                }
            let sortedStoreInfo = [StoreSection(items: sortedItems)]
            return Observable.just(.sortStore(sortedStoreInfo)) // storeInfo 정렬
            // 웹뷰를 닫았을 때
        case .webViewDidDismiss:
            return Observable.just(.dismissWebView) // viewDidmiss
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setStore(let storeInfo):
            newState.storeInfo = storeInfo
        case .shouldPop(let flag):
            newState.shouldPop = flag
            // setCurrentLocation Mutation으로 전달된 위도, 경도 값을 state에 업데이트
        case .setCurrentLocation(lat: let lat, lon: let lon):
            newState.currentLatitude = lat
            newState.currentLongitude = lon
        case .showLocationAlert:
            newState.showLocationAlert = Void()
        case .setWebViewUrl(let uri):
            newState.webViewUrl = uri
            newState.shouldPresentWebView = true
        case .sortStore(let storeInfo):
            newState.storeInfo = storeInfo
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
        return OpeningHours(openNow: openingHours.openNow, periods: periods, weekdayDescriptions: openingHours.weekdayDescriptions)
    }
    
    // 현재 위치와 가게의 거리를 구하는 함수
    func calculateDistance(from lat1: Double, lon1: Double, to lat2: Double, lon2: Double) -> CLLocationDistance {
        let location1 = CLLocation(latitude: lat1, longitude: lon1)
        let location2 = CLLocation(latitude: lat2, longitude: lon2)
        return location1.distance(from: location2)
    }
    
    // 위도와 경도를 받아오는 함수
    private func getCenterLocation() -> (lat: Double, lon: Double) {
        let userLocation = UserDeafaultsManager.shared.readLocation()
        let centerLat = userLocation?.lat ?? 37.5177 // 기본값: 강남역
        let centerLon = userLocation?.lon ?? 127.0473
        return (centerLat, centerLon)
    }
    
    // 권한 설정에 따른 동작을 설정하는 함수
    private func handleLocationAuthorization() -> Observable<Mutation> {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return .empty()
        case .restricted, .authorizedWhenInUse, .authorizedAlways:
            return locationManager.rx.getCurrentLocationOnce
                .flatMap { lat, lon -> Observable<Mutation> in
                    return NetworkManager.shared.fetchGeoCoding(lat: lat, lon: lon)
                        .asObservable()
                        .map { addressTuple in
                            let address = addressTuple.map { "\($0.0) \($0.1)" } ?? "알 수 없는 위치"
                            let location = UserDeafaultsManager.UserLocation(address: address, lat: lat, lon: lon)
                            UserDeafaultsManager.shared.saveLocation(location: location)
                            return .setCurrentLocation(lat: lat, lon: lon)
                        }
                }
        case .denied:
            return .just(.showLocationAlert)
        @unknown default:
            return .empty()
        }
    }
}
