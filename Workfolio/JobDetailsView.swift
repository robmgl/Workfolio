//
//  JobDetailsView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI

struct JobDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: JobListViewModel
    @Binding var job: Job
    @State private var isEditingPresented = false // Track if EditJobView is presented

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "\(job.company.prefix(1).lowercased()).circle.fill")
                .font(.system(size: 45))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
         
                Text(job.company)
                    .font(.system(size: 55))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
            Divider()
            HStack {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.gray)
                Text("Position: \(job.title)")
                    .font(.system(size: 20))
            }
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.gray)
                Text("Status: \(job.status.rawValue)")
                    .font(.system(size: 20))
            }
            if let location = job.location, !location.isEmpty {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text("Location: \(location)")
                        .font(.system(size: 20))
                }
            }
            if let salary = job.salary {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.gray)
                    Text("Salary: \(salary, format: .currency(code: "USD"))")
                        .font(.system(size: 20))
                }
            }
            if let workMode = job.workMode {
                HStack {
                    Image(systemName: "desktopcomputer")
                        .foregroundColor(.gray)
                    Text("Work Mode: \(workMode.rawValue)")
                        .font(.system(size: 20))
                }
            }
            if let updatedDate = job.updatedDate {
                Text("Updated: \(DateFormatter.localizedString(from: updatedDate, dateStyle: .short, timeStyle: .none))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text("Date Added: \(DateFormatter.localizedString(from: job.dateAdded, dateStyle: .short, timeStyle: .none))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()

            HStack {
                Button(action: {
                    isEditingPresented = true // Show EditJobView
                }) {
                    Text("Update Job")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.clear)
                        .foregroundColor(.blue)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
                        .cornerRadius(8)
                        .padding(.bottom, 20)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditingPresented) {
            EditJobView(viewModel: viewModel, job: $job, isPresented: $isEditingPresented)
        }
    }
}

