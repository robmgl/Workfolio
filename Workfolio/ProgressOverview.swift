//
//  ProgressOverview.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/15/24.
//

import SwiftUI

struct ProgressOverview: View {
    @ObservedObject var viewModel: JobListViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Progress Overview")
                .font(.headline)
                .foregroundColor(.secondary)

            let total = viewModel.jobs.count
            let applied = viewModel.jobs.filter { $0.status == .applied }.count
            let interviews = viewModel.jobs.filter {
                [.phoneScreen, .firstInterview, .secondInterview, .finalInterview].contains($0.status)
            }.count
            let offers = viewModel.jobs.filter { $0.status == .offer }.count

            ProgressBar(label: "Applied", value: Double(applied), total: Double(total), color: .blue)
            ProgressBar(label: "Interviews", value: Double(interviews), total: Double(total), color: .orange)
            ProgressBar(label: "Offers", value: Double(offers), total: Double(total), color: .green)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}

struct ProgressBar: View {
    let label: String
    let value: Double
    let total: Double
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 10)
                    Capsule()
                        .fill(color)
                        .frame(width: CGFloat(value / total) * geometry.size.width, height: 10)
                }
            }
            .frame(height: 10)
            Spacer()
            Text("\(Int(value))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
