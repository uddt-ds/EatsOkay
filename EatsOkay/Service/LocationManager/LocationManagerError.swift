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
    case locationServiceTurnedOffOrTemporaryError
}

extension LocationManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noLocationFound:
            return "위치를 찾을 수 없습니다"
        case .noLastestLocationFound:
            return "최근 위치 정보를 찾을 수 없습니다."
        case .locationServiceTurnedOffOrTemporaryError:
            return """
                    위치 서비스를 사용할 수 없습니다.
                    기기의 위치 서비스가 꺼져 있거나,
                    일시적인 문제로 인해 위치 정보를 가져올 수 없습니다.
                    설정을 확인하거나 잠시 후 다시 시도해주세요.
                    """
        }
    }
}
