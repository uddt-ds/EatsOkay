//
//  LocationReactorError.swift
//  EatsOkay
//
//  Created by LCH on 6/13/25.
//

import Foundation

enum LocationReactorError: Error {
    case locationOutsideKorea
}

extension LocationReactorError: LocalizedError {
    var errorDescription: String? {
        
        #if DEBUG
        switch self {
        case .locationOutsideKorea:
            return "Kakao Geocoding API Response를 받을수 있는 지역이 아닙니다."
        }
        
        #else
        switch self {
        case .locationOutsideKorea:
            return "서비스 제공 지역이 아닙니다."
        }
        #endif
    }
}
