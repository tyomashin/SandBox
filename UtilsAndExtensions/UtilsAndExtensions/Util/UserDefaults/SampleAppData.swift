//
//  SampleAppData.swift
//  UtilsAndExtensions
//
//  Created by 岡崎伸也 on 2022/05/19.
//

import Foundation

/// UserDefaults に格納したデータへのアクセスを提供する
internal enum SampleAppData {
    /// 初回起動フラグ
    @AppUserDefaults(key: "firstLaunchFlag", defaultValue: true)
    internal static var firstLaunchFlag: Bool
}
