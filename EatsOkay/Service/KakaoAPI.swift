//
//  KakaoAPI.swift
//  EatsOkay
//
//  Created by 김기태 on 6/12/25.
//

import Foundation
import Moya

enum KakaoAPI {
    case geocoding(lat: Double, lon: Double)
}

extension KakaoAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }
    
    var path: String {
        return "/v2/local/geo/coord2address"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .geocoding(let lat, let lon):
            return .requestParameters(parameters: [
                "x": lon,
                "y": lat
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        guard let apiKey = Bundle.main.infoDictionary?["KakaoAPIKey"] as? String else { return nil }

        return [
            "Authorization": "KakaoAK \(apiKey)"
        ]
    }
    
    
}
