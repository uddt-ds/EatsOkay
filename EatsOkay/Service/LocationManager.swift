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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationRelay.accept(locations)
    }
    
     func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
         
     }
}

extension Reactive where Base: CLLocationManager {
    var delegate: RxCoreLocationManagerDelegateProxy {
        return RxCoreLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var getCurrentLocationOnce: Observable<(lat: Double, lon: Double)> {
        return delegate.locationRelay
            .do(onSubscribe: {
                base.requestLocation()
            })
            .compactMap { params -> (lat: Double, lon: Double)? in
                guard let first = params.first else { return nil }
                let coord = first.coordinate
                return (lat: coord.latitude, lon: coord.longitude)
            }
    }
}
