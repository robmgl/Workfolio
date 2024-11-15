//
//  EmptyStateView.swift
//  Workfolio
//
//  Created by Rob Miguel on 11/15/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 120)
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
            .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 10)
            
            Text("Welcome to Workfolio!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Text("Tap the '+' button to add your first job application. Organize your applications with filters and stay on top of your job search.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
    }
}
