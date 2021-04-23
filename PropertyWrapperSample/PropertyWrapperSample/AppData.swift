//
//  AppData.swift
//  PropertyWrapperSample
//
//  Created by 岡崎伸也 on 2021/04/24.
//

import Foundation

/// UserDefaults に格納したデータへのアクセスを提供する
internal enum AppData {
    /// 初回起動フラグ
    @MyUserDefaults(key: "FirstLaunchFlag", defaultValue: true)
    internal static var firstLaunchFlag: Bool
    
    @MyUserDefaults(key: "Sample", defaultValue: nil)
    internal static var sample: String?
    
    @MyUserDefaults(key: "SampleEnum", defaultValue: nil)
    internal static var sampleEnum: SampleType?
    
}

enum SampleType: Int, Codable, CaseIterable {
    case aaa
    case bbb
}
