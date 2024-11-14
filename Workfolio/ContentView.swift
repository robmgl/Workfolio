//
//  ContentView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JobListViewModel()
    @State private var showingAddJobView = false
    @State private var showingJobDetails = false
    @State private var selectedJob: Job?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.jobs.count > 1 {
                        HStack {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 25))
                            TextField("Search by job title or company", text: $viewModel.searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(1)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding()
                    }
                    if viewModel.filteredJobs.isEmpty {
                        VStack {
                            Image(systemName: "briefcase.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No Applications")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                    } else {
                        VStack {
                            ForEach(viewModel.filteredJobs) { job in
                                JobCardView(viewModel: viewModel, job: job)
                                    .onTapGesture {
                                        selectedJob = job
                                        showingJobDetails = true
                                    }
                                Divider()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Workfolio")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Filter by Status", selection: $viewModel.selectedStatus) {
                            Text("All").tag(JobStatus?.none) // Show all jobs
                            ForEach(JobStatus.allCases) { status in
                                Text(status.rawValue).tag(status as JobStatus?)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle") // Filter icon
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddJobView = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddJobView) {
                AddJobView(viewModel: viewModel)
            }
            .background(
                NavigationLink(
                    destination: selectedJob.map { JobDetailsView(viewModel: viewModel, job: .constant($0)) },
                    isActive: $showingJobDetails,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
}

extension LinearGradient {
    static let blueOrangeGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.orange]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}


#Preview {
    ContentView()
}
