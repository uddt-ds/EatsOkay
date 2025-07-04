//
//  OpeningHours+.swift
//  EatsOkay
//
//  Created by 허성필 on 7/1/25.
//

import Foundation

extension OpeningHours {
    static func getTodayClosingOrTomorrowOpening(openingHours: OpeningHours) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        // 0=일요일, 6=토요일
        let todayWeekday = (calendar.component(.weekday, from: now) + 6) % 7
        let tomorrowWeekday = (todayWeekday + 1) % 7
        let nowHour = calendar.component(.hour, from: now)
        let nowMinute = calendar.component(.minute, from: now)
        let nowMinutes = nowHour * 60 + nowMinute
        
        // 24시간 영업 감지 (periods에 0:00~23:59이거나 weekdayDescriptions에 "24시간" 포함)
        let isAlwaysOpen = openingHours.periods.contains {
            $0.open.hour == 0 && $0.open.minute == 0 &&
            $0.close.hour == 23 && $0.close.minute == 59 &&
            $0.open.day == $0.close.day
        } || (openingHours.weekdayDescriptions?.contains(where: { $0.contains("24시간") }) ?? false)
        if isAlwaysOpen {
            return "24시간 영업"
        }
        
        // 오늘 요일에 해당하는 periods 추출
        let todayPeriods = openingHours.periods.filter { $0.open.day == todayWeekday }
        // 내일 요일에 해당하는 periods 추출
        let tomorrowPeriods = openingHours.periods.filter { $0.open.day == tomorrowWeekday }
        
        // 오늘 새벽(0~6시): 어제 오픈, 오늘 클로즈 period를 찾아야 함
        if nowHour < 6 {
            let yesterdayWeekday = (todayWeekday + 6) % 7
            if let period = openingHours.periods.first(where: {
                $0.open.day == yesterdayWeekday && $0.close.day == todayWeekday
            }) {
                let closeMinutes = period.close.hour * 60 + period.close.minute
                if nowMinutes < closeMinutes {
                    if period.close.hour < 6 {
                        return String(format: "새벽 %02d:%02d 영업 종료", period.close.hour, period.close.minute)
                    } else {
                        return String(format: "%02d:%02d 영업 종료", period.close.hour, period.close.minute)
                    }
                }
            }
        }
        
        // 오늘 영업 중일 때
        if openingHours.openNow {
            var todayCloseTimes: [(Int, Int)] = []
            for period in todayPeriods {
                if period.close.day == todayWeekday {
                    todayCloseTimes.append((period.close.hour, period.close.minute))
                }
            }
            var midnightCloseTimes: [(Int, Int)] = []
            for period in todayPeriods {
                if period.close.day == tomorrowWeekday {
                    midnightCloseTimes.append((period.close.hour, period.close.minute))
                }
            }
            let allCloseTimes = todayCloseTimes + midnightCloseTimes
            if let close = allCloseTimes
                .filter({ hour, minute in
                    let closeMinutes = hour * 60 + minute
                    return closeMinutes > nowMinutes || (hour < 6 && closeMinutes < nowMinutes)
                })
                    .min(by: { lhs, rhs in
                        let lhsValue = lhs.0 * 60 + lhs.1
                        let rhsValue = rhs.0 * 60 + rhs.1
                        return lhsValue < rhsValue
                    }) {
                if close.0 < 6 {
                    return String(format: "새벽 %02d:%02d 영업 종료", close.0, close.1)
                } else {
                    return String(format: "%02d:%02d 영업 종료", close.0, close.1)
                }
            }
        }
        
        // 오늘 요일의 오픈 시간 중, 현재 시간보다 큰(아직 오픈 전) 가장 가까운 오픈 시간 찾기
        let todayOpenTimes = todayPeriods.map { ($0.open.hour, $0.open.minute) }
        if let nextOpen = todayOpenTimes
            .filter({ hour, minute in hour * 60 + minute > nowMinutes })
            .min(by: { lhs, rhs in lhs.0 * 60 + lhs.1 < rhs.0 * 60 + rhs.1 }) {
            // 오늘 영업이 있고, 내일이 휴무인데 아직 오픈 시간 전이면 오늘 오픈 시간 표시
            if tomorrowPeriods.isEmpty {
                return String(format: "%02d:%02d 영업 시작", nextOpen.0, nextOpen.1)
            } else {
                return String(format: "%02d:%02d 영업 시작", nextOpen.0, nextOpen.1)
            }
        }
        
        // 오늘 영업이 없고, 내일이 휴무인 경우
        if tomorrowPeriods.isEmpty {
            // 오늘 영업이 없고, 내일도 영업이 없음 (연속 휴무)
            let nowHour = calendar.component(.hour, from: now)
            // 오후 10시(22시) 이전이면 "오늘 휴무", 이후면 "다음날 휴무"
            if nowHour < 22 {
                return "오늘 휴무"
            } else {
                return "다음날 휴무"
            }
        } else {
            // 내일 영업 시간이 있으면 내일 첫 번째 오픈 시간 표시
            if let firstPeriod = tomorrowPeriods.min(by: {
                ($0.open.hour * 60 + $0.open.minute) < ($1.open.hour * 60 + $1.open.minute)
            }) {
                return String(format: "%02d:%02d 영업 시작", firstPeriod.open.hour, firstPeriod.open.minute)
            }
        }
        return ""
    }
}
