//
//  UserDeafaultsManager.swift
//  EatsOkay
//
//  Created by 김기태 on 6/10/25.
//

import Foundation

// 제네릭 확인
final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys: String {
        case onBoardingKey
        case locationKey
        case photoUriCacheKey
    }
    
    // 메서드 호출 시 true 값 저장
    func saveStatus() {
        defaults.set(true, forKey: Keys.onBoardingKey.rawValue)
    }
    
    // 메서드 호출 시 true or false 값 return
    // true일 때, false일 때로 분기하여 화면전환 로직 구현
    func readStatus() -> Bool {
        return defaults.bool(forKey: Keys.onBoardingKey.rawValue)
    }
    
    // JSON 데이터로 저장
    func saveLocation(location: UserLocation) {
        if let encoded = try? JSONEncoder().encode(location) {
            defaults.set(encoded, forKey: Keys.locationKey.rawValue)
        }
    }
    
    // UserLocation 형태로 불러오기
    func readLocation() -> UserLocation? {
        guard let data = defaults.data(forKey: Keys.locationKey.rawValue) else { return nil }
        return try? JSONDecoder().decode(UserLocation.self, from: data)
    }
    
    func savePhotoUriCache(_ cache: [String: String]) {
        defaults.set(cache, forKey: Keys.photoUriCacheKey.rawValue)
    }

    func readPhotoUriCache() -> [String: String]? {
        return defaults.object(forKey: Keys.photoUriCacheKey.rawValue) as? [String: String]
    }

}
