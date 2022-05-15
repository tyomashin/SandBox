//
//  DateModel.swift
//  EventKitSample
//
//  Created by 岡崎伸也 on 2022/05/11.
//

import Foundation

class DateModel: NSObject {
    static let shared = DateModel()
    
    private let calendar: Calendar
    private var components = DateComponents()
    
    private override init() {
        self.calendar = Calendar.current
        components.calendar = calendar
        super.init()
    }
    
    /// 年月日をDateに変換する
    func getDate(year: Int, month: Int, day: Int) -> Date? {
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        return components.date
    }
}
