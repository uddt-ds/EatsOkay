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

enum Category: Hashable, CaseIterable {
    case all
    case daily
    case workout
    case company
    case love
    case season

    var title: String {
        switch self {
        case .all: return "전체"
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
    let assetImage: String
}
