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

                Divider()

                HStack {
                    Image(systemName: "square.and.pencil.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                    Text("Notes")
                        .font(.headline)
                }
                .padding(.top)
                if isEditingNotes {
                    VStack(alignment: .leading) {
                        TextEditor(text: $editedNotes)
                            .frame(height: 150)
                            .border(Color.gray, width: 1)
                            .onReceive(Just(editedNotes)) { _ in limitText() }
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        hideKeyboard()
                                    }
                                }
                            }
                        Text("\(editedNotes.count)/\(noteCharacterLimit) characters")
                            .font(.caption)
                            .foregroundColor(editedNotes.count > noteCharacterLimit ? .red : .gray)
                            .padding(.top, 5)
                    }
                    .padding(.bottom, 10)

                    HStack {
                        Button("Save") {
                            job.notes = editedNotes
                            viewModel.updateJob(job, newStatus: job.status) // Save the updated notes
                            isEditingNotes = false
                        }
                        .disabled(editedNotes.count > noteCharacterLimit) // Disable if limit exceeded
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
                Spacer()
                HStack {
                    Button(action: {
                        isEditingPresented = true
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
        }
        .background(Color.white)
        .cornerRadius(12)
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditingPresented) {
            EditJobView(viewModel: viewModel, job: $job, isPresented: $isEditingPresented)
        }
    }

    // Helper function to enforce the character limit
    private func limitText() {
        if editedNotes.count > noteCharacterLimit {
            editedNotes = String(editedNotes.prefix(noteCharacterLimit))
        }
    }

    // Helper function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
