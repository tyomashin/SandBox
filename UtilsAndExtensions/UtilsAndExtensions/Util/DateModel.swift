//
//  DateModel.swift
//  UtilsAndExtensions
//
//  Created by 岡崎伸也 on 2022/05/18.
//

import Foundation

struct DateDetails{
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let min: Int
    let sec: Int
}

/// 日時操作を行うクラス
class DateModel: NSObject {
    static let shared = DateModel()
    static let dateTimePerDay = 60 * 60 * 24
    static let dateTimePerHour = 60 * 60
    
    private let calendar: Calendar
    private var components = DateComponents()
    
    private override init() {
        self.calendar = Calendar.current
        components.calendar = calendar
        super.init()
    }
    
    /// 年月日をDateに変換する
    func getDate(year: Int, month: Int, day: Int, hour: Int, min: Int, second: Int) -> Date? {
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = min
        components.second = second
        return components.date
    }
    
    /// Dateから年月日時分秒を取り出す
    func getDateDetails(target: Date) -> DateDetails {
        let year = calendar.component(.year, from: target)
        let month = calendar.component(.month, from: target)
        let day = calendar.component(.day, from: target)
        let hour = calendar.component(.hour, from: target)
        let min = calendar.component(.minute, from: target)
        let sec = calendar.component(.second, from: target)
        return .init(year: year, month: month, day: day, hour: hour, min: min, sec: sec)
    }
    
    /// Date に加算、減算する
    func add(
        targetDate: Date, year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil
    ) -> Date? {
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return calendar.date(byAdding: components, to: targetDate)
    }
}
