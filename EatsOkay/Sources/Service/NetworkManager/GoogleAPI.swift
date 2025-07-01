//
//  GoogleAPI.swift
//  EatsOkay
//
//  Created by 김기태 on 6/10/25.
//

import Foundation
import Moya

enum GoogleAPI {
    // 사각형으로 데이터 불러오기, 이미지 불러오기
    case storeInfoDataRectangle(textQuery: String, locationRestriction: SearchTextBody.LocationRestriction)
    case storeImageData(mediaName: String)
    case staticMapImage(center: String, zoom: Int, size: String)
}

extension GoogleAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .storeInfoDataRectangle, .storeImageData:
            return URL(string: "https://places.googleapis.com")!
        case .staticMapImage:
            return URL(string: "https://maps.googleapis.com")!
        }
    }
    
    var path: String {
        switch self {
        case .storeInfoDataRectangle:
            return "/v1/places:searchText"
           
        
        case .storeImageData(mediaName: let mediaName):
            return "/v1/\(mediaName)/media"
            
        case .staticMapImage:
            return "/maps/api/staticmap"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .storeInfoDataRectangle:
            return .post
            
        case .storeImageData:
            return .get
        
        case .staticMapImage:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        case .storeInfoDataRectangle(textQuery: let textQuery, locationRestriction: let locationRestriction):
            
            let body = SearchTextBody(textQuery: textQuery, locationRestriction: locationRestriction)
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
            
        case .staticMapImage(center: let center, zoom: let zoom, size: let size):
            guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else { return .requestPlain }
            
            let params: [String: Any] = [
                "center": center,
                "zoom": zoom,
                "size": size,
                "key": apiKey
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else { return nil }
        let fieldMask = "places.displayName,places.rating,places.userRatingCount,places.primaryTypeDisplayName,places.formattedAddress,places.currentOpeningHours,places.postalAddress,places.location,places.photos,places.googleMapsUri,places.goodForGroups,places.reservable,places.takeout,places.parkingOptions,places.nationalPhoneNumber,places.id"
        
        switch self {
        case .storeInfoDataRectangle:
            return [
                "Content-Type": "application/json",
                "X-Goog-Api-Key": apiKey,
                "X-Goog-FieldMask": fieldMask
            ]
            
        case .storeImageData:
            return nil
            
        case .staticMapImage:
            return nil
        }
    }
}
