
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
    var identity: String { return displayName } // 고유 식별자로 가게명 사용
}

struct StoreSection {
    var identity: String = "main"
    var items: [StoreInfo]
}

extension StoreSection: AnimatableSectionModelType {
    typealias Item = StoreInfo

    init(original: StoreSection, items: [StoreInfo]) {
        self = original
        self.items = items
    }
}
