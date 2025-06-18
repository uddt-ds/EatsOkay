
import Foundation
import RxDataSources

struct StoreInfo: Equatable {
    let displayName: String
    let primaryTypeDisplayName: String
    let formattedAddress: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let googleMapsUri: String
    let userRatingCount: Int
    let photosNames: String
    let currentOpeningHours: OpeningHours
}

struct OpeningHours: Decodable, Equatable {
    let openNow: Bool
    let periods: [Periods]
    let weekdayDescriptions: [String]?
}

extension OpeningHours {
    struct Periods: Decodable, Equatable {
        let open, close: Close
    }

    struct Close: Decodable, Equatable {
        let day, hour, minute: Int
        let date: DateClass
    }

    struct DateClass: Decodable, Equatable {
        let year, month, day: Int
    }
}

extension StoreInfo: IdentifiableType {
    var identity: String { return UUID().uuidString } // 고유 식별자로 가게명 사용
}

struct StoreSection {
    var identity: String
    var items: [StoreInfo]
    
    init(items: [StoreInfo]) {
        self.identity = UUID().uuidString
        self.items = items
    }
}

extension StoreSection: AnimatableSectionModelType {
    typealias Item = StoreInfo
//    typealias Identity = UUID // Identity 타입을 UUID로 변경

    init(original: StoreSection, items: [StoreInfo]) {
        self = original
        self.items = items
    }
}
