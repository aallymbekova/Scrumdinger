//
//  History.swift
//  Scrumdinger
//
//  Created by Aliya Alymbekova on 29/11/24.
//

import Foundation

struct History: Identifiable, Codable  {
    let id: UUID
    let date: Date
    var attendees: [DailyScrum.Attendee]
    var transcript: String?
    
    init(id: UUID = UUID(), date: Date = Date(), attendees: [DailyScrum.Attendee], transcript: String) {
        self.id = id
        self.date = date
        self.attendees = attendees
        self.transcript = transcript
    }
}
