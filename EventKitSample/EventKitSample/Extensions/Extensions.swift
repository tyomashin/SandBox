//
//  Extensions.swift
//  EventKitSample
//
//  Created by 岡崎伸也 on 2022/05/12.
//

import Foundation
import EventKit
import Contacts

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
        result += "url: \(self.url?.absoluteString), \n"
        result += "notes: \(self.notes), \n"
        result += "isAllDay: \(self.isAllDay), \n"
        result += "attendeesNum: \(self.attendees?.count), \n"
        result += "organizer: \(self.organizer), \n"
        result += "occurrenceDate(繰り返しイベントの開始日時): \(self.occurrenceDate), \n"
        result += "isDetached: \(self.isDetached), \n"
        result += "status: \(self.status.appDebugString), \n"
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
        result += "contactPredicate: \(self.contactPredicate), \n"
        result += "isCurrentUser: \(self.isCurrentUser), \n"
        return result
    }
}

extension EKEventStatus {
    var appDebugString: String {
        switch self {
        case .none:
            return "none"
        case .confirmed:
            return "comfirmed"
        case .tentative:
            return "tentative"
        case .canceled:
            return "canceled"
        default:
            return "unknown"
        }
    }
}

extension CGColor {
    var rgbaStr: String {
        var result = ""
        self.components?.forEach({ result += "\($0 * 255), " })
        return result
    }
}
