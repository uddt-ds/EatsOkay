//
//  SummarySectionModel.swift
//  EatsOkay
//
//  Created by 허성필 on 7/2/25.
//

import Foundation
import RxDataSources

struct SummarySectionModel {
    var section: Section
    var items: [CellModel]
    
    enum Section {
        case summaryImage
        case summaryInfo
        case summaryFeatures
        case summaryMap
        
        var title: String {
            switch self {
            case .summaryImage:
                return "매장 사진"
            case .summaryInfo:
                return "매장 정보"
            case .summaryFeatures:
                return "매장 특징"
            case .summaryMap:
                return "위치"
            }
            
        }
    }
    
    enum CellModel {
        case summaryImageCell(SummaryImageResult)
        case summaryInfoCell(SummaryInfoResult)
        case summaryFeaturesCell(SummaryFeaturesResult)
        case summaryMapCell(SummaryMapResult)
    }
}

extension SummarySectionModel {
    struct SummaryImageResult {
        let photosUrl: [String]
    }
    
    struct SummaryInfoResult {
        let storeName: String
        let storeAddress: String
        let storeType: String
        let rate: String
        let reviewCount: String
        let isOpen: Bool
        let openInfo: String
        let storePhoneNumber: String?
    }
    
    struct SummaryFeaturesResult {
        let goodForGroups: Bool?
        let takeout: Bool?
        let reservable: Bool?
        let parkingOPtions: ParkingOptions?
    }
    
    struct SummaryMapResult {
        let imageUrl: String
        let address: String
    }
}

extension SummarySectionModel : SectionModelType {
    typealias Item = CellModel
    
    init(original: SummarySectionModel, items: [CellModel]) {
        self = original
        self.items = items
    }
    
}

