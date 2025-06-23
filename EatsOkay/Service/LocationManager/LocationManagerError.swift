//
//  LocationManagerError.swift
//  EatsOkay
//
//  Created by LCH on 6/15/25.
//

import Foundation

enum LocationManagerError: Error {
    case noLocationFound
    case noLastestLocationFound
}

extension LocationManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noLocationFound:
            return "위치를 찾을 수 없습니다"
        case .noLastestLocationFound:
            return "최근 위치 정보를 찾을 수 없습니다."
        }
    }
}
