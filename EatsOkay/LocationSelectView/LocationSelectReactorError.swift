//
//  LocationViewError.swift
//  EatsOkay
//
//  Created by LCH on 6/13/25.
//

import Foundation

enum LocationSelectReactorError: Error {
    case failedToGetAddressJSONFilePath
    case failedToConvertAddressJSONToString
    case failedToConvertAddressStringToData
    case failedToDecodeAddressJSON
    case noMatchingAddressAfterFiltering
    case failedToReadLocationFromUserDefaults
}

extension LocationSelectReactorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToGetAddressJSONFilePath:
            return "주소 JSON 파일 경로를 가져오는 데 실패했습니다."
        case .failedToConvertAddressJSONToString:
            return "주소 JSON 데이터를 문자열로 변환하는 데 실패했습니다."
        case .failedToConvertAddressStringToData:
            return "주소 문자열을 Data 형식으로 변환하는 데 실패했습니다."
        case .failedToDecodeAddressJSON:
            return "주소 JSON 데이터를 디코딩하는 데 실패했습니다."
        case .noMatchingAddressAfterFiltering:
            return "필터링 결과에 해당하는 주소가 없습니다."
        case .failedToReadLocationFromUserDefaults:
            return "UserDefaults에서 위치 정보를 읽어오는 데 실패했습니다."
        }
    }
}
