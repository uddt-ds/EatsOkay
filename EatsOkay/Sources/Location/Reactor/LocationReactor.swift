//
//  LocationReactor.swift
//  EatsOkay
//
//  Created by LCH on 6/6/25.
//

import Foundation
import RxSwift
import ReactorKit
import CoreLocation

final class LocationReactor: Reactor {
    
    var disposeBag = DisposeBag()
    private let networkManger = NetworkManager.shared
    
    var initialState: State
    
    init() {
        self.initialState = State(
            pickerViewData: .init(locality: [], subLocalitys: [:]),
            pickerViewFilteredData: [],
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
        case setPickerViewDataList(MatchedLocationListData)
        case setPickerViewFilteredDataList([[String]])
        case setPickerViewInitialRows(firstRow: Int, secondRow: Int)
        case setPickerViewSelectedItem(firstRow: Int, secondRow: Int)
        case setScrolling(Bool)
        case setNextView(Void?)
        case setAlert(Void?)
        case setError(Error?)
    }
    
    struct State {
        fileprivate var pickerViewData: MatchedLocationListData
        var pickerViewFilteredData: [[String]]
        @Pulse var pickerViewinitialRows: (firstRow: Int, secondRow: Int)?
        @Pulse var selectedItem: (firstRow: Int, secondRow: Int)
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
                let locality = returnLocalityArray(from: decodedData)
                let subLocality = returnSubLocalityDicationary(from: decodedData, with: locality)
                
                // UserDefault에 저장된 위치가 없을 경우에 기본값을 서울 강남으로 작성
                var savedLocation: UserLocation
                if let location = UserDefaultsManager.shared.readLocation() {
                    savedLocation = location
                } else {
                    let location = UserLocation(address: "서울 강남구", lat: 37.5177, lon: 127.0473)
                    savedLocation = location
                }
                
                let saveLocationArray = savedLocation.address.split(separator: " ")
                let savedlocality = String(saveLocationArray[0].prefix(2))
                let savedSublcality = String(saveLocationArray[1])
                
                let filteredSubLocality = subLocality[savedlocality]
                
                let localityIndex = locality.firstIndex(of: String(savedlocality))
                let sublocalityIndex = filteredSubLocality?.firstIndex(of: String(savedSublcality))
                
                return Observable.concat(
                    Observable.just(.setPickerViewDataList(
                        MatchedLocationListData(
                            locality: locality,
                            subLocalitys: subLocality
                        )
                    )),
                    
                    Observable.just(.setPickerViewInitialRows(
                        firstRow: localityIndex ?? 0,
                        secondRow: sublocalityIndex ?? 0
                    )),
                    
                    Observable.just(.setPickerViewFilteredDataList(
                        [
                            locality,
                            filteredSubLocality ?? []
                        ]
                    )),
                    
                    Observable.just(.setPickerViewSelectedItem(
                        firstRow: localityIndex ?? 0,
                        secondRow: sublocalityIndex ?? 0
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
                
                return locationManager.rx.authorizationStatusChanged
                    .filter { $0 != .denied }
                    .withUnretained(self)
                    .flatMap { reactor, status in
                        return reactor.checkLocation(locationManager: locationManager)
                    }
                
            case .restricted, .authorizedWhenInUse, .authorizedAlways:
                
                return checkLocation(locationManager: locationManager)
                
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
                rows.secondRow = 0
            } else if component == 1 {
                rows.secondRow = row
            }
            
            let locality = currentState.pickerViewData.locality
            
            let subLocality = currentState.pickerViewData.subLocalitys[locality[rows.firstRow]]
            
            return Observable.concat(
                Observable.just(.setPickerViewFilteredDataList([
                    locality,
                    subLocality ?? []
                ])),
                
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
                let totlaData = currentState.pickerViewData
                let selectedItem = currentState.selectedItem
                let locality = currentState.pickerViewData.locality[selectedItem.firstRow]
                let subLocality = totlaData.subLocalitys[locality]![selectedItem.secondRow]
                let matchedData = try AddressManager.shared.getCoordinates(locality: locality, subLocality: subLocality)
                
                UserDefaultsManager.shared.saveLocation(
                    location: .init(
                        address: "\(locality) \(subLocality)",
                        lat: matchedData.lat,
                        lon: matchedData.lon
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
            
        case let .setPickerViewFilteredDataList(filteredAddressList):
            newState.pickerViewFilteredData = filteredAddressList
            
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
    
    func checkLocation(locationManager: CLLocationManager) -> Observable<Mutation> {
        
        var lat: Double = 0
        var lon: Double = 0
        
        return locationManager.rx.getCurrentLocationOnce
            .withUnretained(self)
            .flatMap { reactor, locationEvent -> Observable<(String, String)?> in
                
                lat = locationEvent.lat
                lon = locationEvent.lon
                
                let guardSWcoord = (lat: 33.1078403, lon: 126.0890561)
                let guardNEcoord = (lat: 38.6111004, lon: 129.5847337)
                
                guard (guardSWcoord.lat...guardNEcoord.lat).contains(lat),
                      (guardSWcoord.lon...guardNEcoord.lon).contains(lon) else {
                    throw LocationReactorError.locationOutsideKorea
                }
                
                return reactor.networkManger.fetchGeoCoding(
                    lat: locationEvent.lat,
                    lon: locationEvent.lon
                )
                .asObservable()
            }
            .flatMap { location -> Observable<UserLocation> in
                guard let location else {
                    return .empty()
                }
                
                let splitedSublocality = location.1.split(separator: " ")
                
                guard let sublocality = splitedSublocality.first else {
                    return .empty()
                }
                
                
                return Observable.just(UserLocation(
                    address: "\(location.0.prefix(2)) \(sublocality)",
                    lat: lat,
                    lon: lon
                ))
            }
            .map { location in
                UserDefaultsManager.shared.saveLocation(location: location)
                return .setNextView(Void())
            }
            .catch({ error in
                return .just(.setError(error))
            })
    }
    
    func returnLocalityArray(from addressList: [LocationListData]) -> [String] {
        var locality = Array(Set(addressList.map { $0.locality })).sorted {
            $0 < $1
        }
        
        let highPriorityLocalities = ["경기", "서울"]
        
        for highPriorityLocality in highPriorityLocalities {
            if let index = locality.firstIndex(of: highPriorityLocality) {
                locality.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
            }
        }
        
        return locality
    }
    
    func returnSubLocalityDicationary(from addressList: [LocationListData], with localityArray: [String]) -> [String: [String]] {
        var subLocalityDictionary: [String: [String]] = [:]
        
        for locality in localityArray {
            let subLocalities = addressList
                .filter { $0.locality == locality }
                .map { $0.subLocality }
            
            subLocalityDictionary[locality] = subLocalities
        }
        
        return subLocalityDictionary
    }
    
}
