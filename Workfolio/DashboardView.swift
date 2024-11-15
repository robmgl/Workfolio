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
        ScrollView {
            VStack(spacing: 20) {
                SummaryCard(title: "Total Applications", value: "\(viewModel.jobs.count)", color: .blue)
                StatusBreakdown(viewModel: viewModel)
                SummaryCard(title: "Success Rate", value: successRateText, color: .green)
                ProgressOverview(viewModel: viewModel)
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }

    private var successRateText: String {
        let totalApplications = viewModel.jobs.count
        let offers = viewModel.jobs.filter { $0.status == .offer }.count
        guard totalApplications > 0 else { return "N/A" }
        let successRate = Double(offers) / Double(totalApplications) * 100
        return String(format: "%.1f%%", successRate)
    }
}
