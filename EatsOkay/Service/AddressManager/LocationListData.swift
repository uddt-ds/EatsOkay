//
//  LocationListData.swift
//  EatsOkay
//
//  Created by LCH on 6/7/25.
//

struct LocationListData: Decodable {
    let locality: String
    let subLocality: String
    let lat: Double
    let lon: Double
}
