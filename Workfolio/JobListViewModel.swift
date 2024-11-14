//
//  JobListViewModel.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI
import Combine

class JobListViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .dateAdded
    @Published var selectedStatus: JobStatus? = nil

    var filteredJobs: [Job] {
        let filteredJobs = jobs.filter { job in
            // Apply search filter
            (searchText.isEmpty || job.title.lowercased().contains(searchText.lowercased()) || job.company.lowercased().contains(searchText.lowercased()))
            // Apply status filter
            && (selectedStatus == nil || job.status == selectedStatus)
        }
        
        switch sortOption {
        case .dateAdded:
            return filteredJobs.sorted { $0.dateAdded > $1.dateAdded }
        case .status:
            return filteredJobs.sorted { $0.status.rawValue < $1.status.rawValue }
        }
    }

    func addJob(company: String, title: String, status: JobStatus, location: String? = nil, salary: Double? = nil, workMode: WorkMode? = nil) {
        let newJob = Job(company: company, title: title, status: status, dateAdded: Date(), location: location, salary: salary, workMode: workMode)
        jobs.append(newJob)
        saveJobs()
    }

    func updateJob(_ job: Job, newStatus: JobStatus) {
        if let index = jobs.firstIndex(where: { $0.id == job.id }) {
            jobs[index].status = newStatus
            jobs[index].updatedDate = Date()
            saveJobs()
        }
    }

    func deleteJob(at offsets: IndexSet) {
        jobs.remove(atOffsets: offsets)
        saveJobs()
    }

    func saveJobs() {
        do {
            let data = try JSONEncoder.custom.encode(jobs)
            UserDefaults.standard.set(data, forKey: "jobs")
        } catch {
            print("Failed to encode jobs: \(error)")
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "jobs") {
            do {
                jobs = try JSONDecoder.custom.decode([Job].self, from: data)
            } catch {
                print("Failed to decode jobs: \(error)")
            }
        }
    }
}

extension JSONEncoder {
    static let custom: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}

extension JSONDecoder {
    static let custom: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

