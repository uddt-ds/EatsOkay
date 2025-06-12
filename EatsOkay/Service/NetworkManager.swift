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

final class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<GoogleAPI>()
    
    private init() {}
    
    func fetchPlacesWithCircle(textQuery: String, centerLat: Double, centerLon: Double) -> Single<[GoogleMap.Place]> {
        return provider.rx.request(.storeInfoDataCircle(textQuery: textQuery, lat: centerLat, lon: centerLon))
              .filterSuccessfulStatusCodes()
              .map(GoogleMap.self)
              .map { $0.places }
      }
    
    func fetchPlacesWithRectangle(textQuery: String, lowLat: Double, lowLon: Double, highLat: Double, highLon: Double) -> Single<[GoogleMap.Place]> {
            return provider.rx.request(.storeInfoDataRectangle(textQuery: textQuery, lowLat: lowLat, lowLon: lowLon, highLat: highLat, highLon: highLon))
                .filterSuccessfulStatusCodes()
                .map(GoogleMap.self)
                .map { $0.places }
        }
    
    func fetchImage(mediaName: String) -> Single<Data> {
        return provider.rx.request(.storeImageData(mediaName: mediaName))
            .filterSuccessfulStatusCodes()
            .map { $0.data }
    }
  }
