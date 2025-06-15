//
//  LocationSelectReactor.swift
//  EatsOkay
//
//  Created by LCH on 6/6/25.
//

import Foundation
import RxSwift
import ReactorKit
import CoreLocation

final class LocationSelectReactor: Reactor {
    
    var disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let networkManger = NetworkManager.shared
    
    var initialState: State
    
    init() {
        self.initialState = State(
            pcikerViewData: [],
            selectedItem: (0, 0)
        )
    }
    
    enum Action {
        case initialFetch
        case locationButtonTapped
        case pickerViewChnaged(component: Int, row: Int)
        case nextButtonTapped
    }
    
    enum Mutation {
        case setPickerViewDataList([[String]])
        case setPickerViewInitialRows(firstRow: Int, secondRow: Int)
        case setPickerViewSelectedItem(firstRow: Int, secondRow: Int)
        case setNextView(Void?)
        case setAlret(Void?)
        case setError(Error?)
    }
    
    struct State {
        @Pulse var pcikerViewData: [[String]]
        @Pulse var pickerViewinitialRows: (firstRow: Int, secondRow: Int)?
        var selectedItem: (firstRow: Int, secondRow: Int)
        @Pulse var nextViewState: Void?
        @Pulse var alretState: Void?
        @Pulse var error: Error?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialFetch:
            
            // TODO: juso.json 파일에서 데이터 불러오는 중복 로직 별도의 Model로 분리
            guard let path = Bundle.main.path(forResource: "juso", ofType: "json") else {
                return Observable.just(.setError(LocationSelectReactorError.failedToGetAddressJSONFilePath))
            }
            
            guard let jsonString = try? String(contentsOfFile: path) else {
                return Observable.just(.setError(LocationSelectReactorError.failedToConvertAddressJSONToString))
            }
            
            guard let data = jsonString.data(using: .utf8) else {
                return Observable.just(.setError(LocationSelectReactorError.failedToConvertAddressStringToData))
            }
            
            guard let decodedData = try? JSONDecoder().decode([LocationListData].self, from: data) else {
                return Observable.just(.setError(LocationSelectReactorError.failedToDecodeAddressJSON))
            }
            
            let locality = Array(Set(decodedData.map { $0.locality }))
            let subLocality = decodedData.map { $0.subLocality }
            
            // UserDefault에 저장된 위치가 없을 경우에 기본값을 서울 강남으로 작성
            var savedLocation: UserDeafaultsManager.UserLocation
            if let location = UserDeafaultsManager.shared.readLocation() {
                savedLocation = location
            } else {
                let location = UserDeafaultsManager.UserLocation(address: "서울 강남구", lat: 37.5177, lon: 127.0473)
                savedLocation = location
            }
            
            let saveLocationArray = savedLocation.address.split(separator: " ")
            let savedlocality = saveLocationArray[0]
            let savedSublcality = saveLocationArray[1]
            
            guard let localityIndex = locality.firstIndex(of: String(savedlocality)) else {
                return Observable.just(.setError(LocationSelectReactorError.noMatchingAddressAfterFiltering))
            }
            
            guard let sublocalityIndex = subLocality.firstIndex(of: String(savedSublcality)) else {
                return Observable.just(.setError(LocationSelectReactorError.noMatchingAddressAfterFiltering))
            }
            
            return Observable.concat(
                Observable.just(.setPickerViewDataList(
                    [
                        locality,
                        subLocality
                    ]
                )),
                
                Observable.just(.setPickerViewInitialRows(
                    firstRow: localityIndex,
                    secondRow: sublocalityIndex
                ))
            )
            
        case .locationButtonTapped:
            
            let status = locationManager.authorizationStatus
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                return .empty()
                
            case .restricted, .authorizedWhenInUse, .authorizedAlways:
                
                var lat: Double = 0
                var lon: Double = 0
                
                locationManager.rx.getCurrentLocationOnce
                    .take(1)
                    .withUnretained(self)
                    .flatMap{ reactor, location -> Observable<(String, String)?> in
                        
                        lat = location.lat
                        lon = location.lon
                        
                        // TODO: 예외처리 추가하기
                        return reactor.networkManger.fetchGeoCoding(
                            lat: location.lat,
                            lon: location.lon)
                        .asObservable()
                    }
                    .flatMap { kakaoResponse -> Observable<UserDeafaultsManager.UserLocation> in
                        guard let address = kakaoResponse else {
                            return .empty()
                        }
                        
                        return .just(UserDeafaultsManager.UserLocation(
                            address: "\(address.0) \(address.1)",
                            lat: lat,
                            lon: lon
                        ))
                    }
                    .subscribe(onNext: { location in
                        UserDeafaultsManager.shared.saveLocation(location: location)
                        dump(UserDeafaultsManager.shared.readLocation())
                    })
                    .disposed(by: disposeBag)
                
                return Observable.just(.setNextView(Void()))
                
            case .denied:
                
                return Observable.just(.setAlret(Void()))
                
            @unknown default:
                return .empty()
            }
            
        case let .pickerViewChnaged(component, row):
            var rows = currentState.selectedItem
            
            if component == 0 {
                rows.firstRow = row
            } else if component == 1 {
                rows.secondRow = row
            }
            
            return Observable.just(
                .setPickerViewSelectedItem(
                    firstRow: rows.firstRow,
                    secondRow: rows.secondRow
                )
            )
            
        case .nextButtonTapped:
            
            let data = currentState.pcikerViewData
            let selectedItem = currentState.selectedItem
            let subLocality = data[1][selectedItem.secondRow]
            
            // TODO: juso.json 파일에서 데이터 불러오는 중복 로직 별도의 Model로 분리
            guard let path = Bundle.main.path(forResource: "juso", ofType: "json") else {
                return Observable.just(.setError(LocationSelectReactorError.failedToGetAddressJSONFilePath))
            }
            guard let jsonString = try? String(contentsOfFile: path) else {
                return Observable.just(.setError(LocationSelectReactorError.failedToConvertAddressJSONToString))
            }
            guard let data = jsonString.data(using: .utf8) else {
                return Observable.just(.setError(LocationSelectReactorError.failedToConvertAddressStringToData))
            }
            guard let decodedData = try? JSONDecoder().decode([LocationListData].self, from: data) else {
                return Observable.just(.setError(LocationSelectReactorError.failedToDecodeAddressJSON))
            }
            
            guard let filteredData = decodedData.filter({ $0.subLocality == subLocality }).first else {
                return Observable.just(.setError(LocationSelectReactorError.noMatchingAddressAfterFiltering))
            }
            
            UserDeafaultsManager.shared.saveLocation(
                location: .init(
                    address: "\(filteredData.locality) \(filteredData.subLocality)",
                    lat: filteredData.lat,
                    lon: filteredData.lon
                )
            )
            
            return Observable.just(.setNextView(Void()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setPickerViewDataList(addressList):
            newState.pcikerViewData = addressList
            
        case let .setPickerViewInitialRows(firstRow, secondRow):
            newState.pickerViewinitialRows = (firstRow, secondRow)
            
        case let .setPickerViewSelectedItem(firstRow, secondRow):
            newState.selectedItem = (firstRow, secondRow)
            
        case let .setNextView(location):
            newState.nextViewState = location
            
        case let .setAlret(alretTriger):
            newState.alretState = alretTriger
            
        case let .setError(error):
            newState.error = error
        }
        
        return newState
    }
}
