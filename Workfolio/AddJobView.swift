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
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Job Details")) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.gray)
                        TextField("Company Name", text: $company)
                    }
                    
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.gray)
                        TextField("Job Title", text: $title)
                    }
                    
                    HStack {
                        Image(systemName: "note.text")
                            .foregroundColor(.gray)
                        Picker("Status", selection: $status) {
                            ForEach(JobStatus.allCases) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                    }
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.gray)
                        TextField("Location", text: $location)
                    }
                    
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.gray)
                        TextField("Salary", value: $salary, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        Image(systemName: "desktopcomputer")
                            .foregroundColor(.gray)
                        Picker("Work Mode", selection: $workMode) {
                            Text("None").tag(WorkMode?.none)
                            ForEach(WorkMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode as WorkMode?)
                            }
                        }
                    }
                }
                
                Button(action: {
                    if company.isEmpty && title.isEmpty {
                        errorMessage = "Company Name and Job Title are required."
                    } else if !company.isEmpty && title.isEmpty {
                        errorMessage = "Job Title is required."
                    } else if company.isEmpty && !title.isEmpty {
                        errorMessage = "Company Name is required."
                    } else {
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
                
                // Display error message if fields are missing
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 5)
                }
            }
            .navigationTitle("Add Job")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                        
                    }
                }
            }
        }
    }
}
