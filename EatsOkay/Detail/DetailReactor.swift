import Foundation
import ReactorKit
import RxSwift
import CoreLocation

class DetailReactor: Reactor {
    var initialState: State
    private var selectedKeywords: [String] // home에서 전달받는 검색 키워드
    var title: String
    private var photoUriCache: [String: String] = [:]
    
    let locationManager = CLLocationManager()
    
    var disposeBag = DisposeBag()
    
    init(sectionData: SectionData) {
        self.selectedKeywords = sectionData.keywords
        self.title = sectionData.title
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
        case .viewDidLoad:
            // 네트워크 통신 하고 zip으로 병합
            let (centerLat, centerLon) = getCenterLocation()
            
            // userDefault에서 캐시 딕셔너리 불러오기
            if let savedCache = UserDeafaultsManager.shared.readPhotoUriCache() {
                photoUriCache = savedCache
            } else {
                    photoUriCache = [:]
            }
            
            // 가게 정보와 이미지까지 비동기로 네트워크 통신
            let firstRequest = fetchStoreInfosWithImages(textQuery: selectedKeywords[0], centerLat: centerLat, centerLon: centerLon)
            let secondRequest = fetchStoreInfosWithImages(textQuery: selectedKeywords[1], centerLat: centerLat, centerLon: centerLon)
            
            return Observable.zip(firstRequest, secondRequest)
                    .map { first, second in
                        let merged = (first + second).sorted { $0.rating > $1.rating }
                        return [StoreSection(items: merged)]
                    }
                    .map { .setStore($0) }
        case .backButtonTapped:
            return .just(.shouldPop(true))
        case .currentLocationSearchButtonTapped(let centerLat, let centerLon):
            let firstRequest = fetchStoreInfosWithImages(textQuery: selectedKeywords[0], centerLat: centerLat, centerLon: centerLon)
            let secondRequest = fetchStoreInfosWithImages(textQuery: selectedKeywords[1], centerLat: centerLat, centerLon: centerLon)
            
            return Observable.zip(firstRequest, secondRequest)
                    .map { first, second in
                        let merged = (first + second).sorted { $0.rating > $1.rating }
                        return [StoreSection(items: merged)]
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
    func convertToStoreInfo(place: GoogleMap.Place, photoUri: String) -> StoreInfo? {
        guard let displayName = place.displayName?.text,
                  let primaryTypeDisplayName = place.primaryTypeDisplayName?.text,
                  let googleMapsUri = place.googleMapsUri,
                  let rating = place.rating,
                  let userRatingCount = place.userRatingCount,
                  let currentOpeningHours = place.currentOpeningHours
            else { return nil }
            
            let convertedOpeningHours = convertOpeningHours(currentOpeningHours)
            
            return StoreInfo(
                displayName: displayName,
                primaryTypeDisplayName: primaryTypeDisplayName,
                formattedAddress: place.formattedAddress,
                latitude: place.location.latitude,
                longitude: place.location.longitude,
                rating: rating,
                googleMapsUri: googleMapsUri,
                userRatingCount: userRatingCount,
                photosNames: photoUri, // photoUri(이미지 URL)를 여기에 저장
                currentOpeningHours: convertedOpeningHours
            )

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
    
    func fetchStoreInfosWithImages(textQuery: String, centerLat: Double, centerLon: Double) -> Observable<[StoreInfo]> {
        return NetworkManager.shared.fetchPlacesWithCircle(
            textQuery: textQuery,
            centerLat: centerLat,
            centerLon: centerLon)
            .flatMap { places in
                Observable.from(places)
                    .flatMap { [weak self] place -> Observable<StoreInfo?> in
                        guard let self else { return .empty() }
                        let placeName = place.photos?.first?.name ?? ""
                        let splitPlaceName = placeName.split(separator: "/")
                        let photoName = place.photos?.first?.name ?? ""
                        
                        // Index out of range error 방지
                        let cacheKey: String
                        if splitPlaceName.count >= 2 {
                            cacheKey = "\(splitPlaceName[0])/\(splitPlaceName[1])"
                        } else if splitPlaceName.count == 1 {
                            cacheKey = String(splitPlaceName[0])
                        } else {
                            cacheKey = ""
                        }
                        
                        return self.fetchPhotoUriWithCache(placeName: cacheKey, photoName: photoName)
                            .asObservable()
                            .map { [weak self] photoUri in
                                guard let self else { return nil }
                                return self.convertToStoreInfo(place: place, photoUri: photoUri)
                            }
                        
                    }
                    .toArray()
                    .map { $0.compactMap { $0 } }
            }
            .asObservable()
        
    }
    
    // photoUri를 캐싱하여 반환하는 함수
    func fetchPhotoUriWithCache(placeName: String, photoName: String) -> Single<String> {
        let cacheKey = placeName
        if let cachedUri = photoUriCache[cacheKey] {
            return .just(cachedUri)
        }
        // photoName이 없으면 빈 문자열 반환
        guard !photoName.isEmpty else { return .just("") }
        // 캐시에 없으면 네트워크 요청
        return NetworkManager.shared.fetchImage(mediaName: photoName)
            .map { [weak self] googleUri in
                guard let self else { return googleUri.photoUri }
                let photoUri = googleUri.photoUri
                self.photoUriCache[cacheKey] = photoUri
                UserDeafaultsManager.shared.savePhotoUriCache(self.photoUriCache)
                return photoUri
            }
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

