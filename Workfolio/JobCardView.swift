//
//  JobCardView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI

struct JobCardView: View {
    @ObservedObject var viewModel: JobListViewModel
    var job: Job

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(job.company)
                        .font(.system(size: 24))
                        .bold()
                    Text(job.title)
                        .font(.system(size: 17))
                    if let location = job.location, !location.isEmpty {
                        Text("Location: \(location)")
                            .font(.subheadline)
                    }
                    if let salary = job.salary {
                        Text("Salary: \(salary, format: .currency(code: "USD"))")
                            .font(.subheadline)
                    }
                    if let workMode = job.workMode {
                        Text("Work Mode: \(workMode.rawValue)")
                            .font(.subheadline)
                    }
                    Text("Status: \(job.status.rawValue)")
                        .font(.subheadline)
                        .bold()
                    if let updatedDate = job.updatedDate {
                        Text("Updated: \(dateFormatter.string(from: updatedDate))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    Text("Date Added: \(dateFormatter.string(from: job.dateAdded))")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    // Add Notes
                    if let notes = job.notes, !notes.isEmpty {
                        Text("Notes: \(notes)")
                            .font(.footnote)
                            .italic()
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(LinearGradient.blueOrangeGradient, lineWidth: 2))
            .shadow(radius: 3)
        }
    }
}
