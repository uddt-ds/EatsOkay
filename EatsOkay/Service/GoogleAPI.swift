//
//  GoogleAPI.swift
//  EatsOkay
//
//  Created by 김기태 on 6/10/25.
//

import Foundation
import Moya

enum GoogleAPI {
    // 원형으로 데이터 불러오기, 사각형으로 데이터 불러오기, 이미지 불러오기
    case storeInfoDataCircle(textQuery: String, lat: Double, lon: Double)
    case storeInfoDataRectangle(textQuery: String, lowLat: Double, lowLon: Double, highLat: Double, highLon: Double)
    case storeImageData(mediaName: String)
}

extension GoogleAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://places.googleapis.com")!
    }
    
    var path: String {
        switch self {
        case .storeInfoDataCircle, .storeInfoDataRectangle:
            return "/v1/places:searchText"
           
        
        case .storeImageData(mediaName: let mediaName):
            return "/v1/\(mediaName)/media"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .storeInfoDataCircle, .storeInfoDataRectangle:
            return .post
            
        case .storeImageData:
            return .get
        
        }
    }
    
    var task: Moya.Task {
        switch self {
        // body를 SearchTextBody로 모델링(circle, rectangle 모두 body가 들어가지만 bias가 달라서 enum case로 정리)
        case .storeInfoDataCircle(textQuery: let textQuery, lat: let lat, lon: let lon):
            let bias = LocationBias.circle(
                Circle(
                    center: Center(latitude: lat, longitude: lon)
                )
            )
            let body = SearchTextBody(textQuery: textQuery, locationBias: bias)
            return .requestJSONEncodable(body)
            
        case .storeInfoDataRectangle(textQuery: let textQuery, lowLat: let lowLat, lowLon: let lowLon, highLat: let highLat, highLon: let highLon):
            let bias = LocationBias.rectangle(
                Rectangle(
                    low: Low(latitude: lowLat, longitude: lowLon),
                    high: High(latitude: highLat, longitude: highLon)
                )
            )
            let body = SearchTextBody(textQuery: textQuery, locationBias: bias)
            return .requestJSONEncodable(body)
            
        case .storeImageData:
            guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else { return .requestPlain }

            let param: [String: Any] = [
                "maxHeightPx": 500,
                "maxWidthPx": 500,
                "key": apiKey,
                "skipHttpRedirect": true
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else { return nil }
        let fieldMask = "places.displayName,places.rating,places.userRatingCount,places.primaryTypeDisplayName,places.formattedAddress,places.currentOpeningHours,places.postalAddress,places.location,places.photos,places.googleMapsUri"
        
        switch self {
        case .storeInfoDataCircle, .storeInfoDataRectangle:
            return [
                "Content-Type": "application/json",
                "X-Goog-Api-Key": apiKey,
                "X-Goog-FieldMask": fieldMask
            ]
            
        case .storeImageData:
            return nil
        }
    }
}
