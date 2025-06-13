
import ReactorKit

class DetailReactor: Reactor {
    var initialState: State = .init()
    
    enum Action {
        case currentLocationButtonTapped
    }

    enum Mutation {
        // 위도, 경도 값을 받아서 현재 위치 State를 업데이트
        case setCurrentLocation(lat: Double, lon: Double)
    }
    
    struct State {
        // 값이 없을 수 있기 때문에 옵셔널 타입으로 정의
        var currentLatitude: Double?
        var currentLongitute: Double?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .currentLocationButtonTapped:
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
//        switch mutation {
//        }
        return newState
    }
}
