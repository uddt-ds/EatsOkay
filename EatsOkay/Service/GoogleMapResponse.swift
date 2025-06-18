//
//  GoogleMapResponse.swift
//  EatsOkay
//
//  Created by 김기태 on 6/11/25.
//

import Foundation

struct GoogleUri: Decodable {
    let name: String
    let photoUri: String
}

struct GoogleMap: Decodable {
    let places: [Place]
}

extension GoogleMap {
    
    struct Place: Decodable {
        let displayName: DisplayName? // 가게이름
        let primaryTypeDisplayName: PrimaryTypeDisplayName? // 가게 카테고리
        let formattedAddress: String // 전체 주소
        let location: Location // 위경도
        let rating: Double? // 별점
        let googleMapsUri: String? // 웹뷰 주소  // googleMapsURI -> googleMapsUri로 수정
        let userRatingCount: Int? // 리뷰 수
        let photos: [Photo]? // 사진요청 쿼리
        let currentOpeningHours: OpeningHours? // 오픈 시간 일->토 순서
        
    }
}

extension GoogleMap.Place {
    
    // 가게이름
    struct DisplayName: Decodable {
        let text : String
    }
    // 가게 카테고리(ex: 일본 음식점)
    struct PrimaryTypeDisplayName: Decodable {
        let text: String
    }
    // 위경도
    struct Location: Decodable {
        let latitude, longitude: Double
    }
    // 사진 요청시 필요한 쿼리
    struct Photo: Decodable {
        let name: String
    }
    // 오픈 시간
    struct OpeningHours: Decodable {
        let openNow: Bool
        let periods: [Periods]
        let weekdayDescriptions: [String]?
    }
    
}

extension GoogleMap.Place.OpeningHours {
    struct Periods: Decodable {
        let open, close: Close
    }
}

extension GoogleMap.Place.OpeningHours.Periods {
    struct Close: Decodable {
        let day, hour, minute: Int
        let date: DateClass
    }
}

extension GoogleMap.Place.OpeningHours.Periods.Close {
    struct DateClass: Decodable {
        let year, month, day: Int
    }
}
