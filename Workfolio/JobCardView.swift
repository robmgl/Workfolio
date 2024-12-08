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
            // Job Details
            VStack(alignment: .leading, spacing: 8) {
                Text(job.company)
                    .font(.system(size: 26, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.leading)

                Text(job.title)
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)

                if let location = job.location, !location.isEmpty {
                    detailRow(icon: "mappin.and.ellipse", text: location)
                }

                if let salary = job.salary {
                    detailRow(icon: "dollarsign.circle", text: formattedCurrency(value: salary))
                }

                if let workMode = job.workMode {
                    detailRow(icon: "desktopcomputer", text: workMode.rawValue)
                }

                detailRow(icon: "checkmark.seal", text: job.status.rawValue)

                // Updated Date without Icon
                if let updatedDate = job.updatedDate {
                    Text("Updated: \(dateFormatter.string(from: updatedDate))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }

                // Date Added without Icon
                Text("Date Added: \(dateFormatter.string(from: job.dateAdded))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }

            // Notes Section
            if let notes = job.notes, !notes.isEmpty {
                Text("Notes: \(notes)")
                    .font(.footnote)
                    .italic()
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // Align all content to the left
        .background(LinearGradient.blueOrangeGradient.opacity(0.1))
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(LinearGradient.blueOrangeGradient, lineWidth: 1))
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }

    private func detailRow(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
    }

    private func formattedCurrency(value: Double?) -> String {
        guard let value = value else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "N/A"
    }
}
