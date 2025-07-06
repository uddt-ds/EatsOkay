
import Foundation
import RxDataSources

struct StoreInfo: Hashable {
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
    let goodForGroups: Bool? // 단체모임
    let takeout: Bool? // 포장
    let reservable: Bool? // 예약
    let parkingOptions: ParkingOptions? // 주차옵션
    let nationalPhoneNumber: String? // 전화번호
    let id: String // 가게 id
    let photos: [Photo]? // 리뷰 이미지들
}

struct OpeningHours: Decodable, Hashable {
    let openNow: Bool
    let periods: [Periods]
    let weekdayDescriptions: [String]?
}

// 주차 옵션
struct ParkingOptions: Decodable, Hashable {
    let freeParkingLot, paidParkingLot, freeStreetParking, paidStreetParking, valetParking, freeGarageParking, paidGarageParking: Bool?
}

struct Photo: Decodable, Hashable {
    let name: String
}

extension OpeningHours {
    struct Periods: Decodable, Hashable {
        let open, close: Close
    }

    struct Close: Decodable, Hashable {
        let day, hour, minute: Int
        let date: DateClass
    }

    struct DateClass: Decodable, Hashable {
        let year, month, day: Int
    }
}

extension StoreInfo: IdentifiableType {
    var identity: String { return id } // 고유 식별자로 가게 id 사용
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
