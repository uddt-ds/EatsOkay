//
//  UserDeafaultsManager.swift
//  EatsOkay
//
//  Created by 김기태 on 6/10/25.
//

import Foundation

// 제네릭 확인
final class UserDeafaultsManager {
    static let shared = UserDeafaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys: String {
        case onBoardingKey
        case locationKey
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
    
    struct UserLocation: Codable {
        let address: String
        let lat: Double
        let lon: Double
    }
}
