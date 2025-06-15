//
//  LocationManager.swift
//  EatsOkay
//
//  Created by LCH on 6/13/25.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay
import RxCocoa

final class RxCoreLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    fileprivate let locationRelay = PublishRelay<[CLLocation]>()
    fileprivate let errorRelay = PublishRelay<Error>()
    
    static func registerKnownImplementations() {
        self.register { parent in
            return RxCoreLocationManagerDelegateProxy(
                parentObject: parent,
                delegateProxy: self
            )
        }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> (any CLLocationManagerDelegate)? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (any CLLocationManagerDelegate)?, to object: CLLocationManager) {
        object.delegate = delegate
    }
    
    // TODO: 위치 요청 하여 정상적으로 Relay로 전달하고 위치서비스를 끄면 이전에 업데이트 된 값이 방출되는 오류가 있음
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last, abs(latest.timestamp.timeIntervalSinceNow) < 5 {
            locationRelay.accept(locations)
        } else {
            errorRelay.accept(LocationManagerError.noLastestLocationFound)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        errorRelay.accept(error)
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate: RxCoreLocationManagerDelegateProxy {
        return RxCoreLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var getCurrentLocationOnce: Single<(lat: Double, lon: Double)> {
        return Single.create { single in
            var isEmitted = false
            
            let resultDisposable = Observable.merge(
                delegate.locationRelay.map { Result<[CLLocation],Error>.success($0) },
                delegate.errorRelay.map { Result<[CLLocation],Error>.failure($0) }
            )
                .take(1)
                .subscribe(onNext: { result in
                    guard !isEmitted else { return }
                    isEmitted = true
                    
                    base.stopUpdatingLocation()
                    
                    switch result {
                    case .success(let locations):
                        if let coordinate = locations.first?.coordinate {
                            single(.success((lat: coordinate.latitude, lon: coordinate.longitude)))
                        } else {
                            single(.failure(LocationManagerError.noLocationFound))
                        }
                    case .failure:
                        single(.failure(LocationManagerError.locationServiceTurnedOffOrTemporaryError))
                    }
                })
            
            base.startUpdatingLocation()
            
            return Disposables.create {
                resultDisposable.dispose()
                base.stopUpdatingLocation()
            }
        }
    }
}
