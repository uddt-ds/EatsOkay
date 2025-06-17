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

extension CLLocationManager: @retroactive HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

final class RxCoreLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    weak private(set) var locationManager: CLLocationManager?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(
            parentObject: locationManager,
            delegateProxy: RxCoreLocationManagerDelegateProxy.self
        )
    }
    
    static func registerKnownImplementations() {
        self.register { parent in
            RxCoreLocationManagerDelegateProxy(locationManager: parent)
        }
    }
}

extension Reactive where Base: CLLocationManager {

    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCoreLocationManagerDelegateProxy.proxy(for: base)
    }

    var getCurrentLocationOnce: Observable<(lat: Double, lon: Double)> {
        base.startUpdatingLocation()
        return delegate.methodInvoked(
            #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        )
        .take(1)
        .compactMap { params in
            base.stopUpdatingLocation()
            let locationArray = params[1] as? [CLLocation]
            guard let coord = locationArray?.first else {
                throw LocationManagerError.noLocationFound
            }
            
            if coord.timestamp.timeIntervalSinceNow > -5 && coord.timestamp.timeIntervalSinceNow < 0  {
                return (lat: coord.coordinate.latitude, lon: coord.coordinate.longitude)
            } else {
                throw LocationManagerError.noLastestLocationFound
            }
        }
        .share()
    }
}

