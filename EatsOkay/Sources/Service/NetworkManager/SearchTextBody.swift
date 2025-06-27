//
//  SearchTextBody.swift
//  EatsOkay
//
//  Created by 김기태 on 6/11/25.
//

import Foundation

struct SearchTextBody: Encodable {
    let textQuery: String
    let pageSize: Int = 10
    let languageCode: String = "ko"
    let locationRestriction: LocationRestriction
}

extension SearchTextBody {
    struct LocationRestriction: Encodable {
        let rectangle : Rectangle
    }
}

extension SearchTextBody.LocationRestriction {
    struct Rectangle: Encodable {
        let low, high: Coordinates
    }
}

extension SearchTextBody.LocationRestriction.Rectangle {
    struct Coordinates: Encodable {
        let latitude: Double
        let longitude: Double
    }
    
}


