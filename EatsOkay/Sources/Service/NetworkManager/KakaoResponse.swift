//
//  KakaoResponse.swift
//  EatsOkay
//
//  Created by 김기태 on 6/12/25.
//

import Foundation

struct KakaoResponse: Decodable {
    let documents: [Documents]
}

extension KakaoResponse {
    struct Documents: Decodable {
        let address: Address
    }
}

extension KakaoResponse.Documents {
    struct Address: Decodable {
        let region1DepthName, region2DepthName: String

        enum CodingKeys: String, CodingKey {
            case region1DepthName = "region_1depth_name"
            case region2DepthName = "region_2depth_name"
        }

    }
}

