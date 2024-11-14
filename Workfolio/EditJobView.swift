//
//  EditJobView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI

struct EditJobView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: JobListViewModel
    @Binding var job: Job

    @State private var newTitle: String
    @State private var newCompany: String
    @State private var newStatus: JobStatus
    @State private var newLocation: String
    @State private var newSalary: Double?

    init(viewModel: JobListViewModel, job: Binding<Job>) {
        self.viewModel = viewModel
        _job = job
        _newTitle = State(initialValue: job.wrappedValue.title)
        _newCompany = State(initialValue: job.wrappedValue.company)
        _newStatus = State(initialValue: job.wrappedValue.status)
        _newLocation = State(initialValue: job.wrappedValue.location ?? "")
        _newSalary = State(initialValue: job.wrappedValue.salary)
    }

    var body: some View {
        Form {
            Section(header: Text("Edit Job Details")) {
                TextField("Company", text: $newCompany)
                TextField("Title", text: $newTitle)
                Picker("Status", selection: $newStatus) {
                    ForEach(JobStatus.allCases) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                TextField("Location", text: $newLocation)
                TextField("Salary", value: $newSalary, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }

            Section {
                Button(action: {
                    // Update job details
                    job.title = newTitle
                    job.company = newCompany
                    job.status = newStatus
                    job.location = newLocation
                    job.salary = newSalary
                    job.updatedDate = Date()
                    viewModel.saveJobs()  // Persist changes
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Edit Job")
    }
}
