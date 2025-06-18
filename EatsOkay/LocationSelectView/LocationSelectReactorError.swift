//
//  LocationSelectReactorError.swift
//  EatsOkay
//
//  Created by LCH on 6/13/25.
//

import Foundation

enum LocationSelectReactorError: Error {
    case locationNotFoundInUserDefaults
    case locationOutsideKorea
}

extension LocationSelectReactorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationNotFoundInUserDefaults:
            return "저장된 위치 정보를 찾을 수 없습니다."
        case .locationOutsideKorea:
            return "현재 위치는 대한민국이 아닙니다."
        }
    }
}
