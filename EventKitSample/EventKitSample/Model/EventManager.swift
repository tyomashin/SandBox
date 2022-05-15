//
//  EventManager.swift
//  EventKitSample
//
//  Created by 岡崎伸也 on 2022/05/11.
//

import Foundation
import EventKit

/// EventKit 経由でカレンダーの操作を行う
/**
 参考：EKEventStore
 https://developer.apple.com/documentation/eventkit/ekeventstore
 */
class EventManager: NSObject {
    static let shared = EventManager()
    
    private let store: EKEventStore
    var isEventAccessGranted = false
    
    private override init() {
        self.store = EKEventStore()
        super.init()
    }
    
    
    /// 現在のカレンダー権限状態を取得する
    func getCurrentAuth() -> Bool {
        EKEventStore.authorizationStatus(for: .event) == .authorized
    }
    
    /// 権限のリクエストを行う
    func requestEventStoreAuth() {
        store.requestAccess(to: .event) { granted, error in
            if let error = error {
                print("request Access Error", error)
            } else {
                print("request Access result:", granted)
                self.isEventAccessGranted = granted
                
                self.authCompleteTest()
            }
        }
    }
    
    private func authCompleteTest() {
        for cal in getCalendars() {
            print(cal, cal.source)
        }
        
        for cal in getCalendars() {
            print(cal.appDebugString)
        }
    }
    
    /// カレンダー一覧を取得する
    func getCalendars() -> [EKCalendar] {
        store.calendars(for: .event)
    }
    
    /// デフォルトカレンダーを取得する
    /// memo: 予定を追加する時に選択されるデフォルトカレンダー
    func getDefaultCalendar() -> EKCalendar? {
        store.defaultCalendarForNewEvents
    }
    
    /// カレンダーを削除する
    /// memo: カレンダーに含まれる予定も全て削除される模様
    func removeCalendar(calendar: EKCalendar) {
        do {
            try store.removeCalendar(calendar, commit: true)
        } catch {
            print("remomveCalendar error", error)
        }
    }
    
    
    /// 指定された範囲内のスケジュールを取得する
    func getEvents(startDate: Date, endDate: Date) -> [EKEvent] {
        let calendars = getCalendars()
        // 予定を検索するためのクエリを生成
        // memo:
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        // イベントを検索
        let events = store.events(matching: predicate)
        return events
    }
    
    /// データベースを最新にする
    func refreshEvents() {
        store.refreshSourcesIfNecessary()
    }
}
