//
//  ViewController.swift
//  EventKitSample
//
//  Created by 岡崎伸也 on 2022/05/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        EventManager.shared.requestEventStoreAuth()
    }
    
    @IBAction func tapButton(_ sender: Any) {
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
    }
}

