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
 
 上記のドキュメントから、カレンダーの操作、イベントの操作周りのドキュメントへ飛べる（目次になっている）
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
        print(store.sources)
        /*
        for cal in getCalendars() {
            print(cal, cal.source)
        }
        
        for cal in getCalendars() {
            print(cal.appDebugString)
        }
        */
    }
}


/// カレンダー周りの操作
/// 参考：https://developer.apple.com/documentation/eventkit/ekeventstore
extension EventManager {
    /// カレンダー一覧を取得する
    func getCalendars() -> [EKCalendar] {
        store.calendars(for: .event)
    }
    
    /// カレンダーを取得する
    func getCalendar(id: String) -> EKCalendar? {
        store.calendar(withIdentifier: id)
    }
    
    /// Sources を取得する
    func getSources(title: String) -> EKSource? {
        store.sources.first(where: { $0.title == title })
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
    
    /// カレンダーを追加する
    /// - Parameters:
    ///   - name: カレンダー名
    ///   - color: 色
    func addCalendar(with name: String, color: CGColor, source: EKSource?) -> EKCalendar? {
        let calendar = EKCalendar(for: .event, eventStore: store)
        calendar.title = name
        calendar.cgColor = color
        // iCloud や Gmail といったアカウント情報が「source」になる
        calendar.source = source
        
        do {
            try store.saveCalendar(calendar, commit: true)
            SampleAppData.calendarId = calendar.calendarIdentifier
            
            print("saveCalendar, ", calendar.calendarIdentifier)
            return calendar
        } catch {
            print("error saveCalendar, ", error)
            return nil
        }
    }
}

/// イベント周りの操作
/**
 memo
 ・EKEvent: https://developer.apple.com/documentation/eventkit/ekevent
 ・EKCalendarItem: https://developer.apple.com/documentation/eventkit/ekcalendaritem
 */
extension EventManager {
    /// イベントの追加
    func addEvent(
        with calendar: EKCalendar,
        title: String,
        location: String,
        url: URL?,
        notes: String?,
        startDate: Date,
        endDate: Date,
        isAllDay: Bool
    ) {
        let event = EKEvent(eventStore: store)
        // EKCalendarItem クラスのプロパティを設定
        event.calendar = calendar
        event.title = title
        event.location = location
        event.timeZone = TimeZone.current
        event.url = url
        event.notes = notes
        // EKEvent クラスのプロパティを設定
        event.startDate = startDate
        event.endDate = endDate
        event.isAllDay = isAllDay
        
        do {
            try store.save(event, span: .thisEvent, commit: true)
        } catch {
            print("error saveEvent, ", error)
        }
    }
    
    /// ゲストを追加する
    /// memo: 非公式な方法なので参考コード
    func addAttendee(target event: EKEvent) {
        // TODO:
    }
    
    /// アラームを追加する
    func addAlarm(target event: EKEvent) {
        // TODO:
    }
    
    /// 繰り返しルールを追加する
    /// memo: 単一の繰り返しルールしかサポートされていないらしいので replace としている
    /// 参考：https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507256-addrecurrencerule
    func replaceRecurrenceRule(target event: EKEvent) {
        // TODO:
    }
    
    /// 指定された範囲内のスケジュールを取得する
    func getEvents(calendars: [EKCalendar], startDate: Date, endDate: Date) -> [EKEvent] {
        // 予定を検索するためのクエリを生成
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
