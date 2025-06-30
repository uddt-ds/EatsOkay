//
//  NetworkManager.swift
//  EatsOkay
//
//  Created by 김기태 on 6/11/25.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    // 여러개의 API를 사용할 때 MultiTarget 사용
    private let provider = MoyaProvider<MultiTarget>()
    
    private init() {}
    
    // 사각형 구역(남서쪽 좌표, 북동쪽 좌표 필요함)에서 정보 가져오는 메서드
    func fetchPlacesWithRectangle(textQuery: String, locationRestriction: SearchTextBody.LocationRestriction) -> Single<[GoogleMap.Place]> {
        return provider.rx.request(
            MultiTarget(GoogleAPI.storeInfoDataRectangle(textQuery: textQuery, locationRestriction: locationRestriction))
            )
        .filterSuccessfulStatusCodes()
        .map(GoogleMap.self)
        .map { $0.places }
    }
    // 이미지 가져오는 메서드
    func fetchImage(mediaName: String) -> Single<GoogleUri> {
        return provider.rx.request(
            MultiTarget(GoogleAPI.storeImageData(mediaName: mediaName))
        )
        .filterSuccessfulStatusCodes()
        .map(GoogleUri.self) // name, photoUri 둘 다 오는 상황
    }
    // 튜플 형식(서울, 종로구)으로 좌표를 주소로 변경하는 메서드
    func fetchGeoCoding(lat: Double, lon: Double) -> Single<(String, String)?> {
        return provider.rx.request(
            MultiTarget(KakaoAPI.geocoding(lat: lat, lon: lon))
        )
        .filterSuccessfulStatusCodes()
        .map(KakaoResponse.self)
        .map { response in
            guard let address = response.documents.first?.address else { return nil }
            return (address.region1DepthName, address.region2DepthName)
        }
    }
    func fetchStaticMap(center: String, zoom: Int, size: String) -> Single<UIImage?> {
        return provider.rx.request(
            MultiTarget(GoogleAPI.staticMapImage(center: center, zoom: zoom, size: size))
        )
        .filterSuccessfulStatusCodes()
        .map { response in
            UIImage(data: response.data)
        }
    }
}
