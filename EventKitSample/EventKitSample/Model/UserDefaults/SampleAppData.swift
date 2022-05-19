//
//  SampleAppData.swift
//  EventKitSample
//
//  Created by 岡崎伸也 on 2022/05/19.
//

import Foundation

/// UserDefaults に格納したデータへのアクセスを提供する
internal enum SampleAppData {
    @AppUserDefaults(key: "calendarId", defaultValue: nil)
    internal static var calendarId: String?
    
    
}
