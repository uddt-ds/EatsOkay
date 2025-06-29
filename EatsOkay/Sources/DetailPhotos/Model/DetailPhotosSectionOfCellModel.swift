//
//  DetailPhotosSectionOfCellModel.swift
//  EatsOkay
//
//  Created by Lee on 6/28/25.
//

import Foundation
import RxDataSources

struct DetailPhotosSectionOfCellModel {
    var section: Section
    var items: [CellModel]
}

extension DetailPhotosSectionOfCellModel {
    enum Section {
        case mainPhotosSection
        case totalPhotosSection

        var headerTitle: String {
            switch self {
            case .mainPhotosSection: return "메인"
            case .totalPhotosSection: return "전체"
            }
        }
    }

    enum CellModel {
        case mainPhotosSection(imageName: String)
        case totalPhotosSection(imageName: String)
    }
}

extension DetailPhotosSectionOfCellModel: SectionModelType {
    typealias Item = CellModel

    init(original: DetailPhotosSectionOfCellModel, items: [CellModel]) {
        self = original
        self.items = items
    }
}
