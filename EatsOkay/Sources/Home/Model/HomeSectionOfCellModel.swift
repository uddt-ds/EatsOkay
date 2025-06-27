//
//  HomeSectionOfCellModel.swift
//  EatsOkay
//
//  Created by Lee on 6/11/25.
//

import Foundation
import RxDataSources

struct HomeSectionOfCellModel {
    var section: Section
    var items: [CellModel]
    var title: String
}

extension HomeSectionOfCellModel {
    enum Section {
        case cardSection
    }
}

// 애니메이션 구현을 위해 AnimatableSectionModelType을 채택하였습니다
extension HomeSectionOfCellModel: AnimatableSectionModelType {

    typealias Identity = String
    typealias Item = CellModel

    // title을 ID로 해서 식별이 가능하도록 설정(상황별 이름을 식별자로 사용)
    var identity: String {
        return title
    }

    // AnimatableSectionModelType을 구현할 때 요구하는 생성자
    init(original: HomeSectionOfCellModel, items: [CellModel]) {
        self = original
        self.items = items
    }

    /*
     각 섹션에 들어갈 CellModel
     IdentifiableType: RxDataSources에서 셀을 구분하는 프로토콜
     Hashable: diffing(빠른 차이 비교)을 위해 필요
     */
    enum CellModel: IdentifiableType, Hashable {
        typealias Identity = Int

        // 각 셀을 구분하는 구분 값. hashValue를 통해 구분
        var identity: Identity {
            return self.hashValue
        }

        case cardSection(SectionData)
    }
}
