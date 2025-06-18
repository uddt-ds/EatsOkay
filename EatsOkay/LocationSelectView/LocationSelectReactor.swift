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
    private let networkManger = NetworkManager.shared
    
    var initialState: State
    
    init() {
        self.initialState = State(
            pickerViewData: [],
            selectedItem: (0, 0),
            isScrolling: false
        )
    }
    
    enum Action {
        case initialFetch
        case locationButtonTapped
        case panGestureBegan
        case pickerViewChanged(component: Int, row: Int)
        case nextButtonTapped
    }
    
    enum Mutation {
        case setPickerViewDataList([[String]])
        case setPickerViewInitialRows(firstRow: Int, secondRow: Int)
        case setPickerViewSelectedItem(firstRow: Int, secondRow: Int)
        case setScrolling(Bool)
        case setNextView(Void?)
        case setAlert(Void?)
        case setError(Error?)
    }
    
    struct State {
        @Pulse var pickerViewData: [[String]]
        @Pulse var pickerViewinitialRows: (firstRow: Int, secondRow: Int)?
        var selectedItem: (firstRow: Int, secondRow: Int)
        var isScrolling: Bool
        @Pulse var nextViewState: Void?
        @Pulse var alertState: Void?
        @Pulse var error: Error?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialFetch:
            
            do {
                let decodedData = try AddressManager.shared.getAddressList()
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
                    return Observable.just(.setError(AddressManagerError.noMatchingAddressAfterFiltering))
                }
                
                guard let sublocalityIndex = subLocality.firstIndex(of: String(savedSublcality)) else {
                    return Observable.just(.setError(AddressManagerError.noMatchingAddressAfterFiltering))
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
                    )),
                    
                    Observable.just(.setPickerViewSelectedItem(
                        firstRow: localityIndex,
                        secondRow: sublocalityIndex
                    ))
                )
                
            } catch {
                return Observable.just(.setError(error))
            }
            
        case .locationButtonTapped:
            let locationManager = CLLocationManager()
            
            let status = locationManager.authorizationStatus
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                return .empty()
                
            case .restricted, .authorizedWhenInUse, .authorizedAlways:
                var lat: Double = 0
                var lon: Double = 0
                
                return locationManager.rx.getCurrentLocationOnce
                    .withUnretained(self)
                    .flatMap { reactor, locationEvent -> Observable<(String, String)?> in
                        
                        lat = locationEvent.lat
                        lon = locationEvent.lon
                        
                        let guardSWcoord = (lat: 34.3607042, lon: 126.0890561)
                        let guardNEcoord = (lat: 38.6111004, lon: 129.5847337)
                        
                        guard (guardSWcoord.lat...guardNEcoord.lat).contains(lat),
                              (guardSWcoord.lon...guardNEcoord.lon).contains(lon) else {
                            throw LocationSelectReactorError.locationOutsideKorea
                        }
                        
                        return reactor.networkManger.fetchGeoCoding(
                            lat: locationEvent.lat,
                            lon: locationEvent.lon
                        )
                        .asObservable()
                    }
                    .flatMap { location -> Observable<UserDeafaultsManager.UserLocation> in
                        guard let location else {
                            return .empty()
                        }
                        
                        return Observable.just(UserDeafaultsManager.UserLocation(
                            address: "\(location.0) \(location.1)",
                            lat: lat,
                            lon: lon
                        ))
                        
                    }
                    .map { location in
                        UserDeafaultsManager.shared.saveLocation(location: location)
                        return .setNextView(Void())
                    }
                    .catch({ error in
                        return .just(.setError(error))
                    })
                
            case .denied:
                
                return Observable.just(.setAlert(Void()))
                
            @unknown default:
                return .empty()
            }
            
        case .panGestureBegan:
            return Observable.just(.setScrolling(true))
            
        case let .pickerViewChanged(component, row):
            var rows = currentState.selectedItem
            
            if component == 0 {
                rows.firstRow = row
            } else if component == 1 {
                rows.secondRow = row
            }
            
            return Observable.concat(
                Observable.just(
                    .setPickerViewSelectedItem(
                        firstRow: rows.firstRow,
                        secondRow: rows.secondRow
                    )
                ),
                
                Observable.just(.setScrolling(false))
            )
            
        case .nextButtonTapped:
            
            do {
                let data = currentState.pickerViewData
                let selectedItem = currentState.selectedItem
                let subLocality = data[1][selectedItem.secondRow]
                let filteredData = try AddressManager.shared.getCoordinates(with: subLocality)
                
                UserDeafaultsManager.shared.saveLocation(
                    location: .init(
                        address: "\(filteredData.locality) \(filteredData.subLocality)",
                        lat: filteredData.lat,
                        lon: filteredData.lon
                    )
                )
                
                return Observable.just(.setNextView(Void()))
                
            } catch {
                return Observable.just(.setError(error))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setPickerViewDataList(addressList):
            newState.pickerViewData = addressList
            
        case let .setPickerViewInitialRows(firstRow, secondRow):
            newState.pickerViewinitialRows = (firstRow, secondRow)
            
        case let .setPickerViewSelectedItem(firstRow, secondRow):
            newState.selectedItem = (firstRow, secondRow)
            newState.isScrolling = false
        
        case let .setScrolling(bool):
            newState.isScrolling = bool
            
        case let .setNextView(location):
            newState.nextViewState = location
            
        case let .setAlert(alretTriger):
            newState.alertState = alretTriger
            
        case let .setError(error):
            newState.error = error
        }
        
        return newState
    }
}
