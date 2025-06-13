
import ReactorKit
import CoreLocation
import RxSwift

class DetailReactor: Reactor {
    var initialState: State = .init()
    
    enum Action {
        case backButtonTapped
        case currentLocationButtonTapped
    }
    
    enum Mutation {
        case shouldPop(Bool)
        case setCurrentLocation(lat: Double, lon: Double)
    }
    
    struct State {
        var shouldPop: Bool = false
        // 값이 없을 수 있기 때문에 옵셔널 타입으로 정의
        var currentLatitude: Double?
        var currentLongitute: Double?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
        // mock data
        let mockData = CLLocationCoordinate2D(latitude: 37.5171, longitude: 127.0412)
        return Observable.just(mockData)
    }
}
