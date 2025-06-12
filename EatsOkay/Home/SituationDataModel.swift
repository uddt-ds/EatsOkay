//
//  SituationModel.swift
//  SampleProject
//
//  Created by Lee on 6/8/25.
//

import Foundation

struct SituationDataModel {
    let category: Category
    let sections: [SectionData]
}

enum Category: Hashable {
    case daily
    case workout
    case company
    case love
    case season

    var title: String {
        switch self {
        case .daily: return "일상"
        case .workout: return "운동"
        case .company: return "직장"
        case .love: return "연애"
        case .season: return "계절"
        }
    }
}

struct SectionData: Hashable {
    let title: String
    let hashTags: [String]
    let keywords: [String]
    let category: Category
//    let imageName: String     asset에 이미지 추가하고, Manager에도 해당 이름 추가해야함
}
