//
//  UnixTimeModel.swift
//  UtilsAndExtensions
//
//  Created by 岡崎伸也 on 2022/05/18.
//

import Foundation

/// Unix時間を使って目的の情報を取り出すクラス
class UnixTimeModel {
    /// UnixTime を年月日時分秒に変換する
    /// 参考：https://stackoverflow.com/questions/7960318/math-to-convert-seconds-since-1970-into-date-and-vice-versa
    /// - Parameters:
    ///   - unixTime: UnixTime
    ///   - diffFromTimeZone: GMT時間からの時差
    func getDateDetails(unixTime: Int, diffFromTimeZone: Int = 0) -> DateDetails {
        let targetUnitTime = unixTime + diffFromTimeZone
        let z = (targetUnitTime / 86400) + 719468
        let era = (z > 0 ? z : z - 146096) / 146097
        let doe = z - era * 146097
        let yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365
        var y = yoe + era * 400
        let doy = doe - (365*yoe + yoe/4 - yoe/100)
        let mp = (5 * doy + 2) / 153
        let d = doy - (153 * mp + 2)/5 + 1
        let m = mp + (mp < 10 ? 3 : -9)
        y += (m <= 2 ? 1 : 0)
        let hour = (targetUnitTime / 3600) % 24
        let minute = (targetUnitTime / 60) % 60
        let sec = targetUnitTime % 60
        return .init(year: y, month: m, day: d, hour: hour, min: minute, sec: sec)
    }
}
