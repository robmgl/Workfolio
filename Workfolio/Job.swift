//
//  Job.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI
import Combine

enum JobStatus: String, CaseIterable, Identifiable, Codable {
    case applied = "Applied ✅"
    case phoneScreen = "Phone Screen 📞"
    case firstInterview = "First Interview 🙂"
    case secondInterview = "Second Interview 😃"
    case finalInterview = "Final Interview 😁"
    case onSite = "On Site 🏢"
    case offer = "Offer 🥳"
    case questionable = "Questionable❓"
    case rejected = "Rejected ❌"
    case toApply = "To Apply ☑️"
    
    var id: String { rawValue }
}

struct Job: Identifiable, Codable {
    let id: String
    var company: String
    var title: String
    var status: JobStatus
    var dateAdded: Date
    var updatedDate: Date?
    var location: String?
    var salary: Double?
    var workMode: WorkMode?
    var notes: String?

    init(
        id: String = UUID().uuidString,
        company: String,
        title: String,
        status: JobStatus,
        dateAdded: Date,
        updatedDate: Date? = nil,
        location: String? = nil,
        salary: Double? = nil,
        workMode: WorkMode? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.company = company
        self.title = title
        self.status = status
        self.dateAdded = dateAdded
        self.updatedDate = updatedDate
        self.location = location
        self.salary = salary
        self.workMode = workMode
        self.notes = notes
    }
}
