//
//  Extensions.swift
//  EventKitSample
//
//  Created by 岡崎伸也 on 2022/05/12.
//

import Foundation
import EventKit

extension EKCalendar {
    var appDebugString: String {
        var result = ""
        result += "title: \(self.title), \n"
        result += "color: \(self.cgColor?.colorSpace?.name), \(self.cgColor.rgbaStr), \n"
        result += "id: \(self.calendarIdentifier), \n"
        result += "type: \(self.source), \n"
        return result
    }
}

extension EKEvent {
    var appDebugString: String {
        var result = ""
        result += "title: \(self.title), \n"
        result += "location: \(self.location), \n"
        result += "timezone: \(self.timeZone), \n"
        result += "url: \(self.url), \n"
        result += "notes: \(self.notes), \n"
        result += "attendeesNum: \(self.attendees?.count), \n"
        result += "organizer: \(self.organizer), \n"
        for tmp in self.attendees ?? [] {
            result += "attendee: \(tmp.appDebugString), \n"
        }
        
//        result += "title: \(self.title), \n"
//        result += "title: \(self.title), \n"
        return result
    }
}

extension EKParticipant {
    var appDebugString: String {
        var result = ""
        result += "name: \(self.name), \n"
        result += "isCurrentUser: \(self.isCurrentUser), \n"
        return result
    }
}

extension CGColor {
    var rgbaStr: String {
        var result = ""
        self.components?.forEach({ result += "\($0 * 255), " })
        return result
    }
}
