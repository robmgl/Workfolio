//
//  WorkMode.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/13/24.
//

enum WorkMode: String, CaseIterable, Identifiable, Codable {
    case onSite = "On Site"
    case hybrid = "Hybrid"
    case remote = "Remote"
    
    var id: String { rawValue }
}
