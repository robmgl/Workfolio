//
//  EditJobView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI
import Combine

struct EditJobView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: JobListViewModel
    @Binding var job: Job
    @Binding var isPresented: Bool

    @State private var newTitle: String
    @State private var newCompany: String
    @State private var newStatus: JobStatus
    @State private var newLocation: String
    @State private var newSalary: Double?
    @State private var newWorkMode: WorkMode?
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false

    let textLimit = 20

    init(viewModel: JobListViewModel, job: Binding<Job>, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        _job = job
        _isPresented = isPresented
        _newTitle = State(initialValue: job.wrappedValue.title)
        _newCompany = State(initialValue: job.wrappedValue.company)
        _newStatus = State(initialValue: job.wrappedValue.status)
        _newLocation = State(initialValue: job.wrappedValue.location ?? "")
        _newSalary = State(initialValue: job.wrappedValue.salary)
        _newWorkMode = State(initialValue: job.wrappedValue.workMode)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Job Details")) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.gray)
                        TextField("Company", text: $newCompany)
                            .onReceive(Just(newCompany)) { _ in limitText(&newCompany, textLimit) }
                    }
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.gray)
                        TextField("Title", text: $newTitle)
                            .onReceive(Just(newTitle)) { _ in limitText(&newTitle, textLimit) }
                    }
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(.gray)
                        Picker("Status", selection: $newStatus) {
                            ForEach(JobStatus.allCases) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray)
                        TextField("Location (optional)", text: $newLocation)
                            .onReceive(Just(newLocation)) { _ in limitText(&newLocation, textLimit) }
                    }
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.gray)
                        TextField("Salary (optional)", value: $newSalary, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Image(systemName: "desktopcomputer")
                            .foregroundColor(.gray)
                        Picker("Work Mode", selection: $newWorkMode) {
                            Text("None").tag(WorkMode?.none)
                            ForEach(WorkMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode as WorkMode?)
                            }
                        }
                    }
                }
                
                Button(action: {
                    if newCompany.isEmpty && newTitle.isEmpty {
                        errorMessage = "Company Name and Job Title are required."
                    } else if !newCompany.isEmpty && newTitle.isEmpty {
                        errorMessage = "Job Title is required."
                    } else if newCompany.isEmpty && !newTitle.isEmpty {
                        errorMessage = "Company Name is required."
                    } else {
                        job.title = newTitle
                        job.company = newCompany
                        job.status = newStatus
                        job.location = newLocation
                        job.salary = newSalary
                        job.workMode = newWorkMode
                        job.updatedDate = Date()
                        viewModel.saveJobs()
                        isPresented = false // Dismiss the view
                    }
                }) {
                    Text("Save Changes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 5)
                }
                
                Button(action: {
                    showingDeleteAlert = true // Trigger delete confirmation
                }) {
                    Text("Delete Job")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Delete Job"),
                        message: Text("Are you sure you want to delete this job?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let index = viewModel.jobs.firstIndex(where: { $0.id == job.id }) {
                                viewModel.jobs.remove(at: index)
                                viewModel.saveJobs()
                                isPresented = false // Dismiss the view
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Edit Job")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }

    // Function to enforce the character limit
    func limitText(_ text: inout String, _ upper: Int) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
}

