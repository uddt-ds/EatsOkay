
import ReactorKit
import CoreLocation
import RxSwift

class DetailReactor: Reactor {
    var initialState: State = .init()
    
    enum Action {
        case viewDidLoad
        case backButtonTapped
        case currentLocationButtonTapped
    }
    
    enum Mutation {
        case setStore([StoreSection])
        case shouldPop(Bool)
        case setCurrentLocation(lat: Double, lon: Double)
    }
    
    struct State {
        var storeInfo = [StoreSection]()
        var shouldPop: Bool = false
        // 값이 없을 수 있기 때문에 옵셔널 타입으로 정의
        var currentLatitude: Double?
        var currentLongitute: Double?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            // 네트워크 통신 하고 zip으로 병합
            let firstRequest = NetworkManager.shared.fetchPlacesWithCircle(textQuery: "스시", centerLat: 37.5665, centerLon: 126.9780)
                .map { self.convertToStoreInfo(places: $0) }
                .asObservable()
            
            let secondRequest = NetworkManager.shared.fetchPlacesWithCircle(textQuery: "스테이크", centerLat: 37.5665, centerLon: 126.9780)
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
        case .backButtonTapped:
            return .just(.shouldPop(true))
        case .currentLocationButtonTapped:
            return getCurrentLocation()
                .flatMap { coordinate -> Observable<Mutation> in
                    // 위도, 경도로 시/도 역지오코딩
                    return NetworkManager.shared.fetchGeoCoding(lat: coordinate.latitude, lon: coordinate.longitude)
                        // single 타입을 Observable로 변환
                        .asObservable()
                        .map { addressTuple -> Mutation in
                            let address = addressTuple.map { "($0.0) \($0.1)" } ?? "알 수 없는 위치"
                            let location = UserDeafaultsManager.UserLocation(address: address, lat: coordinate.latitude, lon: coordinate.longitude)
                            // UserDeafaultsManager에 위치 저장
                            UserDeafaultsManager.shared.saveLocation(location: location)
                            return .setCurrentLocation(lat: coordinate.latitude, lon: coordinate.longitude)
                        }
                }
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
            newState.currentLongitute = lon
        }
        return newState
    }
    
    // CLManager에서 위도, 경도 값 받기
    private func getCurrentLocation() -> Observable<CLLocationCoordinate2D> {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        
        return manager.rx.getCurrentLocationOnce
            .map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon) }
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
}
