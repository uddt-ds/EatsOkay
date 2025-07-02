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
    }

    enum CellModel {
        case mainPhotosSection(imageName: String)
        case totalPhotosSection(imageName: String, isSelected: Bool)
    }
}

extension DetailPhotosSectionOfCellModel: SectionModelType {
    typealias Item = CellModel

    init(original: DetailPhotosSectionOfCellModel, items: [CellModel]) {
        self = original
        self.items = items
    }
}
