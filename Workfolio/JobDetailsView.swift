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

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    private var companyInitial: String {
        String(job.company.prefix(1)).lowercased()
    }

    private var companyIconName: String {
        "\(companyInitial).circle.fill"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: companyIconName)
                .font(.system(size: 100))
                .foregroundColor(.gray)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundColor(.gray)
                Text("Company: \(job.company)")
                    .font(.system(size: 30))
                    .bold()
            }
            HStack {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.gray)
                Text("Position: \(job.title)")
                    .font(.system(size: 30))
            }
            HStack {
                Image(systemName: "note.text")
                    .foregroundColor(.gray)
                Text("Status: \(job.status.rawValue)")
                    .font(.system(size: 20))
                    .bold()
            }
            if let location = job.location, !location.isEmpty {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                    Text("Location: \(location)")
                        .font(.subheadline)
                }
            }
            if let salary = job.salary {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.gray)
                    Text("Salary: \(salary, format: .currency(code: "USD"))")
                        .font(.subheadline)
                }
            }
            if let workMode = job.workMode {
                HStack {
                    Image(systemName: "desktopcomputer")
                        .foregroundColor(.gray)
                    Text("Work Mode: \(workMode.rawValue)")
                        .font(.subheadline)
                }
            }
            if let updatedDate = job.updatedDate {
                Text("Updated: \(dateFormatter.string(from: updatedDate))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text("Date Added: \(dateFormatter.string(from: job.dateAdded))")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                NavigationLink(destination: EditJobView(viewModel: viewModel, job: $job)) {
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
        .shadow(radius: 15)
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
