//
//  SearchTextBody.swift
//  EatsOkay
//
//  Created by 김기태 on 6/11/25.
//

import Foundation

struct SearchTextBody: Encodable {
    let textQuery: String
    let pageSize: Int = 1
    let languageCode: String = "ko"
    let locationBias: LocationBias
}

enum LocationBias: Encodable {
    case circle(Circle)
    case rectangle(Rectangle)
    
    enum CodingKeys: String, CodingKey {
        case circle
        case rectangle
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .circle(let circle):
            try container.encode(circle, forKey: .circle)
        case .rectangle(let rectangle):
            try container.encode(rectangle, forKey: .rectangle)
        }
    }
}

struct Circle: Encodable {
    let center: Center
    // 미터단위, 1000m = 1km
    let radius: Int = 1000
}

struct Center: Encodable {
    let latitude: Double
    let longitude: Double
}

struct Rectangle: Encodable {
    let low: Low
    let high: High
}

struct Low: Encodable {
    let latitude: Double
    let longitude: Double
}

struct High: Encodable {
    let latitude: Double
    let longitude: Double
}
