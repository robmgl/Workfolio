//
//  AddJobView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI

struct AddJobView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: JobListViewModel

    @State private var company: String = ""
    @State private var title: String = ""
    @State private var status: JobStatus = .toApply
    @State private var location: String = ""
    @State private var salary: Double?
    @State private var workMode: WorkMode? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Job Details")) {
                    TextField("Company Name", text: $company)
                    TextField("Job Title", text: $title)
                    Picker("Status", selection: $status) {
                        ForEach(JobStatus.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    TextField("Location", text: $location)
                    TextField("Salary", value: $salary, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    Picker("Work Mode", selection: $workMode) {
                        Text("None").tag(WorkMode?.none)
                        ForEach(WorkMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode as WorkMode?)
                        }
                    }
                }
                Button(action: {
                    if !company.isEmpty && !title.isEmpty {
                        viewModel.addJob(company: company, title: title, status: status, location: location, salary: salary, workMode: workMode)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Add Job")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.headline)
                }
            }
            .navigationTitle("Add Job")
        }
    }
}
