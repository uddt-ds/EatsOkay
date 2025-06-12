//
//  DetailModel.swift
//  EatsOkay
//
//  Created by 허성필 on 6/11/25.
//

import Foundation
import RxDataSources

struct StoreInfo: Equatable {
    let displayName: String
    let formattedAddress: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let googleMapsURI: String
    let userRatingCount: Int
    let photosNames: [String]
}

extension StoreInfo: IdentifiableType {
    var identity: String { return displayName } // 고유 식별자로 가게명 사용
}

struct StoreSection {
    var items: [StoreInfo]
}

extension StoreSection: AnimatableSectionModelType {
    typealias Item = StoreInfo
    typealias Identity = String
    
    var identity: String { "default" }
    init(original: StoreSection, items: [StoreInfo]) {
        self = original
        self.items = items
    }
}
