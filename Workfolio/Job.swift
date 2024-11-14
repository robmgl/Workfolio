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

class Job: ObservableObject, Identifiable, Codable {
    let id: String
    @Published var company: String
    @Published var title: String
    @Published var status: JobStatus
    @Published var dateAdded: Date
    @Published var updatedDate: Date?
    @Published var location: String?
    @Published var salary: Double?
    @Published var workMode: WorkMode?

    private enum CodingKeys: String, CodingKey {
        case id, company, title, status, dateAdded, updatedDate, location, salary, workMode
    }

    init(id: String = UUID().uuidString, company: String, title: String, status: JobStatus, dateAdded: Date, updatedDate: Date? = nil, location: String? = nil, salary: Double? = nil, workMode: WorkMode? = nil) {
        self.id = id
        self.company = company
        self.title = title
        self.status = status
        self.dateAdded = dateAdded
        self.updatedDate = updatedDate
        self.location = location
        self.salary = salary
        self.workMode = workMode
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        company = try container.decode(String.self, forKey: .company)
        title = try container.decode(String.self, forKey: .title)
        status = try container.decode(JobStatus.self, forKey: .status)
        dateAdded = try container.decode(Date.self, forKey: .dateAdded)
        updatedDate = try? container.decode(Date.self, forKey: .updatedDate)
        location = try? container.decode(String.self, forKey: .location)
        salary = try? container.decode(Double.self, forKey: .salary)
        workMode = try? container.decode(WorkMode.self, forKey: .workMode)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(company, forKey: .company)
        try container.encode(title, forKey: .title)
        try container.encode(status, forKey: .status)
        try container.encode(dateAdded, forKey: .dateAdded)
        try? container.encode(updatedDate, forKey: .updatedDate)
        try? container.encode(location, forKey: .location)
        try? container.encode(salary, forKey: .salary)
        try? container.encode(workMode, forKey: .workMode)
    }
}
