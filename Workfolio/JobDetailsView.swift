//
//  JobDetailsView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

import SwiftUI
import Combine

struct JobDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: JobListViewModel
    @Binding var job: Job
    @State private var isEditingPresented = false
    @State private var isEditingNotes = false
    @State private var editedNotes: String = ""
    let noteCharacterLimit = 300

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header Section
                VStack(alignment: .center) {
                    Image(systemName: "\(job.company.prefix(1).lowercased()).circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text(job.company)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)

                Divider()

                // Job Details Section
                detailRow(icon: "doc.text.fill", title: "Position", value: job.title)
                detailRow(icon: "note.text", title: "Status", value: job.status.rawValue)
                
                if let location = job.location, !location.isEmpty {
                    detailRow(icon: "mappin.and.ellipse", title: "Location", value: location)
                }

                if let salary = job.salary {
                    detailRow(
                        icon: "dollarsign.circle.fill",
                        title: "Salary",
                        value: formattedCurrency(value: salary)
                    )
                }


                if let workMode = job.workMode {
                    detailRow(icon: "desktopcomputer", title: "Work Mode", value: workMode.rawValue)
                }

                if let updatedDate = job.updatedDate {
                    detailRow(
                        icon: "calendar",
                        title: "Updated",
                        value: DateFormatter.localizedString(from: updatedDate, dateStyle: .medium, timeStyle: .none)
                    )
                }

                detailRow(
                    icon: "clock",
                    title: "Date Added",
                    value: DateFormatter.localizedString(from: job.dateAdded, dateStyle: .medium, timeStyle: .none)
                )

                Divider()

                // Notes Section
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .foregroundColor(.gray)
                        Text("Notes")
                            .font(.headline)
                    }

                    if isEditingNotes {
                        VStack(alignment: .leading) {
                            TextEditor(text: $editedNotes)
                                .frame(height: 150)
                                .border(Color.gray, width: 1)
                                .onReceive(Just(editedNotes)) { _ in limitText() }
                            Text("\(editedNotes.count)/\(noteCharacterLimit) characters")
                                .font(.caption)
                                .foregroundColor(editedNotes.count > noteCharacterLimit ? .red : .gray)
                                .padding(.top, 5)
                        }

                        HStack {
                            Button("Save") {
                                var updatedJob = job
                                updatedJob.notes = editedNotes
                                viewModel.updateJob(updatedJob)
                                isEditingNotes = false
                            }
                            .disabled(editedNotes.count > noteCharacterLimit)
                            .padding()
                            .background(editedNotes.count > noteCharacterLimit ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)

                            Button("Cancel") {
                                isEditingNotes = false
                            }
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    } else {
                        if let notes = job.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.body)
                                .padding(.vertical, 5)
                        } else {
                            Text("No notes added yet.")
                                .foregroundColor(.gray)
                                .italic()
                        }

                        Button("Edit Notes") {
                            editedNotes = job.notes ?? ""
                            isEditingNotes = true
                        }
                        .padding(.top, 5)
                        .foregroundColor(.blue)
                    }
                }

                Spacer()

                // Footer Section
                Button(action: {
                    isEditingPresented = true
                }) {
                    Text("Edit Job")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditingPresented) {
            EditJobView(viewModel: viewModel, job: $job, isPresented: $isEditingPresented)
        }
    }

    // Helper to create detail rows
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text("\(title):")
                .fontWeight(.semibold)
            Text(value)
                .font(.body)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }

    // Helper to enforce the character limit
    private func limitText() {
        if editedNotes.count > noteCharacterLimit {
            editedNotes = String(editedNotes.prefix(noteCharacterLimit))
        }
    }
}

func formattedCurrency(value: Double?) -> String {
    guard let value = value else { return "N/A" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    return formatter.string(from: NSNumber(value: value)) ?? "N/A"
}


