//
//  UserDeafaultsManager.swift
//  EatsOkay
//
//  Created by 김기태 on 6/10/25.
//

import Foundation

// 제네릭 확인, 열거형 key
final class UserDeafaultsManager {
    static let shared = UserDeafaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private let onBoardingKey = "hasSeenOnBoarding"
    private let locationKey = "userLocation"
    
    // 메서드 호출 시 true 값 저장
    func saveStatus() {
        defaults.set(true, forKey: onBoardingKey)
    }
    
    // 메서드 호출 시 true or false 값 return
    // true일 때, false일 때로 분기하여 화면전환 로직 구현
    func readStatus() -> Bool {
        return defaults.bool(forKey: onBoardingKey)
    }
    
    // JSON 데이터로 저장
    func saveLocation(location: UserLocation) {
        if let encoded = try? JSONEncoder().encode(location) {
            defaults.set(encoded, forKey: locationKey)
        }
    }
    
    // UserLocation 형태로 불러오기
    func readLocation() -> UserLocation? {
        guard let data = defaults.data(forKey: locationKey) else { return nil }
        return try? JSONDecoder().decode(UserLocation.self, from: data)
    }
    
    struct UserLocation: Codable {
        let address: String
        let lat: Double
        let lon: Double
    }
}
