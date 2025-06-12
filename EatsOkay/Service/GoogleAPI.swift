//
//  GoogleAPI.swift
//  EatsOkay
//
//  Created by 김기태 on 6/10/25.
//

import Foundation
import Moya
import RxSwift

enum GoogleAPI {
    case storeInfoDataCircle(textQuery: String, lat: Double, lon: Double)
    case storeInfoDataRectangle(textQuery: String, lowLat: Double, lowLon: Double, highLat: Double, highLon: Double)
    case storeImageData(mediaName: String)
}

extension GoogleAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://places.googleapis.com/v1")!
    }
    
    var path: String {
        switch self {
        case .storeInfoDataCircle, .storeInfoDataRectangle:
            return "/places:searchText"
           
        
        case .storeImageData(mediaName: let mediaName):
            let encodedName = mediaName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? mediaName
            return "/\(encodedName)/media"
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
            
        case .storeImageData(mediaName: let mediaName):
            guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else { return .requestPlain }

            let param: [String: Any] = [
                "maxHeightPx": 500,
                "maxWidthPx": 500,
                "key": apiKey
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else { return nil }
        let fieldMask = "places.displayName,places.rating,places.userRatingCount,places.primaryTypeDisplayName,places.formattedAddress,places.currentOpeningHours,places.postalAddress,places.location,places.photos,places.googleMapsUri"
        
        switch self {
        case .storeInfoDataCircle:
            return [
                "Content-Type": "application/json",
                "X-Goog-Api-Key": apiKey,
                "X-Goog-FieldMask": fieldMask
            ]
            
        case .storeInfoDataRectangle:
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
