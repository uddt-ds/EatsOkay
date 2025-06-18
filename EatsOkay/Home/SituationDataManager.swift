//
//  SituationDataManager.swift
//  SampleProject
//
//  Created by Lee on 6/8/25.
//

import Foundation
import UIKit

struct SituationDataManager {
    private let dailySituationsData: SituationDataModel =
    SituationDataModel(
        category: .daily,
        sections: [
            SectionData(title: "고생한 나에게 주는 보상",
                        hashTags: ["#시험 끝", "#자유"],
                        keywords: ["치킨", "족발"],
                        category: .daily,
                        assetImage: .daily1),
            SectionData(title: "늦게 일어났어도 밥은 먹자",
                        hashTags: ["#아점", "#브런치"],
                        keywords: ["브런치", "포케"],
                        category: .daily,
                        assetImage: .daily2),
            SectionData(title: "내 통장.. 눈감아",
                        hashTags: ["#텅장", "#카드값"],
                        keywords: ["김밥", "분식"],
                        category: .daily,
                        assetImage: .daily3),
            SectionData(title: "밖에 비온다 주륵주륵",
                        hashTags: ["#비", "#막걸리"],
                        keywords: ["파전", "칼국수"],
                        category: .daily,
                        assetImage: .daily4),
            SectionData(title: "음식도 선물이 될 수 있다",
                        hashTags: ["#생일", "#기념일"],
                        keywords: ["파스타", "오마카세"],
                        category: .daily,
                        assetImage: .daily5),
            SectionData(title: "아파도 밥은 챙겨먹자",
                        hashTags: ["#건강", "#감기"],
                        keywords: ["죽", "삼계탕"],
                        category: .daily,
                        assetImage: .daily6),
            SectionData(title: "쓰린 속, 진하게 달래기",
                        hashTags: ["#해장", "#국물"],
                        keywords: ["쌀국수", "국밥"],
                        category: .daily,
                        assetImage: .daily7)
        ]
    )

    private let workoutSituationsData: SituationDataModel =
    SituationDataModel(
        category: .workout,
        sections: [
            SectionData(title: "칼로리... 눈 감아..",
                        hashTags: ["#치팅데이", "#우걱우걱"],
                        keywords: ["버거", "피자"],
                        category: .workout,
                        assetImage: .workout1),
            SectionData(title: "그래도 건강하게 먹어야지",
                        hashTags: ["#다이어트", "#유지어터"],
                        keywords: ["포케", "키토"],
                        category: .workout,
                        assetImage: .workout2),
            SectionData(title: "벌크업 벌크업 마시자",
                        hashTags: ["#벌크업", "#고기"],
                        keywords: ["소고기", "스테이크"],
                        category: .workout,
                        assetImage: .workout3),
            SectionData(title: "답답하면 너가 먹던가",
                        hashTags: ["#조기축구", "#운동 회식"],
                        keywords: ["부대찌개", "닭한마리"],
                        category: .workout,
                        assetImage: .workout4),
            SectionData(title: "달리자, 2차까지",
                        hashTags: ["#러닝크루", "#운동 회식"],
                        keywords: ["삼겹살", "치킨"],
                        category: .workout,
                        assetImage: .workout5),
            SectionData(title: "삐빅, 정상입니다",
                        hashTags: ["#등산", "#막걸리"],
                        keywords: ["파전", "막걸리"],
                        category: .workout,
                        assetImage: .workout6)
        ]
    )

    private let companySituationsData: SituationDataModel =
    SituationDataModel(
        category: .company,
        sections: [
            SectionData(title: "이왕 먹는거 비싼거 먹자",
                        hashTags: ["#회사", "#가족같은 회사"],
                        keywords: ["고기", "양꼬치"],
                        category: .company,
                        assetImage: .company1),
            SectionData(title: "오늘만큼은 내가 만수르",
                        hashTags: ["#월급날", "#일일부자"],
                        keywords: ["스시", "와인바"],
                        category: .company,
                        assetImage: .company2),
            SectionData(title: "말은 아팠어도 밥은 따뜻하게",
                        hashTags: ["#상사", "#피드백"],
                        keywords: ["마라탕", "불족발"],
                        category: .company,
                        assetImage: .company3),
            SectionData(title: "퇴근 후 자유의 맛",
                        hashTags: ["#불금", "#자유"],
                        keywords: ["삼겹살", "회"],
                        category: .company,
                        assetImage: .company4),
            SectionData(title: "퇴근을 당겨주는 간단한 음식",
                        hashTags: ["#야근", "#간편식"],
                        keywords: ["김밥", "햄버거"],
                        category: .company,
                        assetImage: .company5)
        ]
    )

    private let loveSituationsData: SituationDataModel =
    SituationDataModel(
        category: .love,
        sections: [
            SectionData(title: "이거 먹으면 나랑 사귀는거다",
                        hashTags: ["#소개팅", "#썸"],
                        keywords: ["파스타", "스시"],
                        category: .love,
                        assetImage: .love1),
            SectionData(title: "아이고~ 식사합시다",
                        hashTags: ["#상견례", "#예의"],
                        keywords: ["한정식", "중식"],
                        category: .love,
                        assetImage: .love2),
            SectionData(title: "기념일을 더욱 특별하게",
                        hashTags: ["#기념일", "#선물"],
                        keywords: ["이탈리안", "스시"],
                        category: .love,
                        assetImage: .love3),
            SectionData(title: "잔디밭 위, 맛있는 휴식",
                        hashTags: ["#피크닉", "#소풍"],
                        keywords: ["샌드위치", "피자"],
                        category: .love,
                        assetImage: .love4),
            SectionData(title: "말 끝마다 설레는 저녁",
                        hashTags: ["#썸", "#쌈"],
                        keywords: ["샤브샤브", "스시"],
                        category: .love,
                        assetImage: .love5),
            SectionData(title: "지나간 사람은 음식으로 잊자",
                        hashTags: ["#이별", "#스트레스"],
                        keywords: ["마라탕", "떡볶이"],
                        category: .love,
                        assetImage: .love6),
            SectionData(title: "진정한 파이터는 푸드파이터지",
                        hashTags: ["#싸움", "#다툼"],
                        keywords: ["닭발", "마라탕"],
                        category: .love,
                        assetImage: .love7)
        ]
    )

    private let seasonSituationsData: SituationDataModel =
    SituationDataModel(
        category: .season,
        sections: [
            SectionData(title: "비키니 드루와",
                        hashTags: ["#여름", "#휴가"],
                        keywords: ["포케", "키토"],
                        category: .season,
                        assetImage: .season1),
            SectionData(title: "더위 먹지말고 대신 먹자",
                        hashTags: ["#보양식", "#건강"],
                        keywords: ["삼계탕", "장어"],
                        category: .season,
                        assetImage: .season2),
            SectionData(title: "죽어가던 입맛을 살려낸 음식",
                        hashTags: ["#콩국수", "#입맛"],
                        keywords: ["냉면", "콩국수"],
                        category: .season,
                        assetImage: .season3),
            SectionData(title: "떠나요~ 둘이서~",
                        hashTags: ["#휴가", "#여행"],
                        keywords: ["스테이크", "피자"],
                        category: .season,
                        assetImage: .season4)
        ]
    )

    /**
     개별 섹션의 데이터를 return하는 함수입니다
     Category: daily, workout, company, love, season
     */
    func loadCategoryData(category: Category) -> SituationDataModel {
        switch category {
        case .all:
            let allSectionData = [
                dailySituationsData,
                workoutSituationsData,
                companySituationsData,
                loveSituationsData,
                seasonSituationsData
            ]
                .flatMap {
                    $0.sections
                }

            return SituationDataModel(
                category: .all,
                sections: allSectionData
            )
        case .daily:
            return dailySituationsData
        case .workout:
            return workoutSituationsData
        case .company:
            return companySituationsData
        case .love:
            return loveSituationsData
        case .season:
            return seasonSituationsData
        }
    }

    /**
     전체 섹션 데이터를 가져오기 위한 함수입니다
     */
    func loadTotalShuffledData() -> [SectionData] {
        let totalData: [Category] = [.daily, .workout, .company, .love, .season]
        let totalSectionArray = totalData.map { loadCategoryData(category: $0).sections }

        let maxCount = totalSectionArray.map { $0.count }.max() ?? 0

        var shuffledSections = [SectionData]()

        for i in 0..<maxCount {
            for sectionArray in totalSectionArray {
                if i < sectionArray.count {
                    shuffledSections.append(sectionArray[i])
                }
            }
        }

        return shuffledSections
    }
}
