//
//  DashboardView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/15/24.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: JobListViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        SummaryCard(title: "Total Applications", value: "\(viewModel.jobs.count)", color: .blue)
                        SummaryCard(title: "Success Rate", value: successRateText, color: .green)
                    }
                    StatusBreakdown(viewModel: viewModel)
                    ProgressOverview(viewModel: viewModel)
                }
                .padding()
                .onAppear {
                    refreshDashboardData()
                } // Trigger refresh when the tab is opened
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var successRateText: String {
        let totalApplications = viewModel.jobs.count
        let offers = viewModel.jobs.filter { $0.status == .offer }.count
        guard totalApplications > 0 else { return "N/A" }
        let successRate = Double(offers) / Double(totalApplications) * 100
        return String(format: "%.1f%%", successRate)
    }

    private func refreshDashboardData() {
        // Explicitly notify the viewModel to recalculate or ensure updates are observed
        viewModel.objectWillChange.send()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: JobListViewModel())
    }
}
