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

    // Computed property for filtered jobs
    var filteredJobs: [Job] {
        if searchText.isEmpty {
            return jobs
        } else {
            return jobs.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.company.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func addJob(company: String, title: String, status: JobStatus, location: String? = nil, salary: Double? = nil, workMode: WorkMode? = nil) {
        let newJob = Job(company: company, title: title, status: status, dateAdded: Date(), location: location, salary: salary, workMode: workMode)
        jobs.append(newJob)
        saveJobs()
    }

    // Method to update a job's status and save changes
    func updateJob(_ job: Job, newStatus: JobStatus) {
        if let index = jobs.firstIndex(where: { $0.id == job.id }) {
            jobs[index].status = newStatus
            jobs[index].updatedDate = Date()
            saveJobs()
        }
    }

    // Method to delete jobs at specific offsets and save changes
    func deleteJob(at offsets: IndexSet) {
        jobs.remove(atOffsets: offsets)
        saveJobs()
    }

    // Method to save jobs array to UserDefaults
    func saveJobs() {
        do {
            let data = try JSONEncoder.custom.encode(jobs)
            UserDefaults.standard.set(data, forKey: "jobs")
        } catch {
            print("Failed to encode jobs: \(error)")
        }
    }

    // Initializer to load jobs from UserDefaults
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

// Extensions to provide custom encoding and decoding strategies for dates
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

