//
//  LocationSelectReactorError.swift
//  EatsOkay
//
//  Created by LCH on 6/13/25.
//

import Foundation

enum LocationSelectReactorError: Error {
    case locationOutsideKorea
}

extension LocationSelectReactorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationOutsideKorea:
            return "현재 위치는 대한민국이 아닙니다."
        }
    }
}
