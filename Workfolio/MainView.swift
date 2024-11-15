//
//  MainView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/15/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = JobListViewModel() // Corrected line

    var body: some View {
        TabView {
            // First Tab: Job Applications (ContentView)
            ContentView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Jobs")
                }

            // Second Tab: Dashboard
            DashboardView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Dashboard")
                }
        }
    }
}

#Preview {
    MainView()
}
