//
//  UIColor+.swift
//  EatsOkay
//
//  Created by Lee on 6/11/25.
//

import UIKit

extension UIColor {
    enum CustomColor: String {
        case bgColor = "FFFFFF"
        case neutral950 = "1F1F1F"
        case neutral800 = "4D4D4D"
        case neutral700 = "5F5F5F"
        case neutral400 = "9F9F9F"
        case neutral200 = "CACACA"
        case neutral100 = "DFDFDF"
        case neutral50 = "F5F5F5"
        case primary600 = "C10B2F"
        case primary400 = "F44366"
        case primary50 = "FEECEF"
        case secondary100 = "FFDEBE"
        case secondary50 = "FFF5EB"
        case starColor = "FFCC00"
        case infoColor = "007AFF"
        case closedColor = "FF161A"
    }
}

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        // 전달받은 hexCode 문자열에서 공백/줄바꿈 제거하고, 대문자로 변환
        let hexFormatted = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // 문자 수가 6자리인지 확인
        assert(hexFormatted.count == 6, "Invalid hex code used.")

        // hexCode를 16진수 숫자로 파싱하여 rgbValue에 저장
        // 예: "F44366" → 0xF44366 → rgbValue = 16030246
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        // 16진수로 저장된 RGB 값을 각각 red, green, blue로 분리한 후, UIColor로 초기화
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    static func customColor(hexCode: CustomColor) -> UIColor {
        return UIColor(hexCode: hexCode.rawValue)
    }
}
