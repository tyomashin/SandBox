//
//  ViewController.swift
//  EventKitSample
//
//  Created by 岡崎伸也 on 2022/05/11.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        EventManager.shared.requestEventStoreAuth()
    }
    
    @IBAction func tapButton(_ sender: Any) {
        // アプリ用のカレンダーを準備
        /*
        var calendar: EKCalendar?
        if let calendarId = SampleAppData.calendarId, let targetCalendar = EventManager.shared.getCalendar(id: calendarId) {
            calendar = targetCalendar
            print("current calendar setup.")
        } else {
            // カレンダー作成
            calendar = EventManager.shared.addCalendar(with: "テストカレンダー", color: UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
            print("new calendar setup.")
        }
        */
        
        /*
        // イベントを作成
        if let calendar = calendar {
            guard let startDate = DateModel.shared.getDate(year: 2024, month: 8, day: 1, hour: 0, min: 0, second: 0),
                    let finishDate = DateModel.shared.getDate(year: 2025, month: 1, day: 1, hour: 0, min: 0, second: 0) else { return }
            // イベント作成
            createEvents(calendar: calendar, startDate: startDate, finishDate: finishDate)
        }
        */
        
        /*
        // イベントを取得する
        let date = Date()
        print("start search event")
        guard let startDate = DateModel.shared.getDate(year: 2021, month: 1, day: 1, hour: 0, min: 0, second: 0),
                let finishDate = DateModel.shared.getDate(year: 2025, month: 1, day: 1, hour: 0, min: 0, second: 0) else { return }
        // イベント作成
        let events = EventManager.shared.getEvents(calendars: EventManager.shared.getCalendars(), startDate: startDate, endDate: finishDate)
        print("end search event", Date().timeIntervalSince(date), events.count)
        */
        
        /*
        let date = Date()
        let startDate = DateModel.shared.getDate(year: 2021, month: 1, day: 1)!
        let endDate = DateModel.shared.getDate(year: 2023, month: 1, day: 1)!
        
        let events = EventManager.shared.getEvents(startDate: startDate, endDate: endDate)
        
        print("finish", Date().timeIntervalSince(date), events.count)
        
        for event in events {
            print(event.appDebugString)
//            if let attendess = event.attendees {
//                //attendess.first?.
//                print(attendess, event.notes, event.organizer, event.status, event.url)
//            }
        }
        */
    }
}

extension ViewController {
    
    /// 指定期間内のイベントを追加する
    func createEvents(calendar: EKCalendar, startDate: Date, finishDate: Date) {
        print("start create events")
        
        var nextDate = startDate
        
        let randomModel = RandomModel()
        let url = URL(string: "https://www.google.com/")
        
        while true {
            guard nextDate < finishDate else { break }
            print("try create event,", nextDate)
            guard let endDate = DateModel.shared.add(targetDate: nextDate, minute: 60) else { break }
            let title = "test スケジュール"
            let notes = randomModel.randomString(length: 30)
            // let isAllDay = Int.random(in: 0...1) == 0 ? true : false
            EventManager.shared.addEvent(with: calendar, title: title, location: "東京駅", url: url, notes: notes, startDate: nextDate, endDate: endDate, isAllDay: false)
            
            nextDate = endDate
        }
        
        print("finish create events")
    }
}

extension ViewController {
    /// Googleカレンダーにスケジュールを追加
    func setupGoogleCalendar() {
        
    }
}
