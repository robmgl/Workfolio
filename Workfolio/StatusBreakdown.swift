//
//  StatusBreakdown.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/15/24.
//

import SwiftUI

struct StatusBreakdown: View {
    @ObservedObject var viewModel: JobListViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Applications by Status")
                .font(.headline)
                .foregroundColor(.secondary)

            ForEach(JobStatus.allCases) { status in
                HStack {
                    Text(status.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(viewModel.jobs.filter { $0.status == status }.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}
