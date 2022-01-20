//
//  ProjectSummaryView.swift
//  UltimatePortfolio
//
//  Created by Simon Shen on 1/20/22.
//

import SwiftUI

struct ProjectSummaryView: View {
  @ObservedObject var project: Project
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("\(project.projectItems.count)")
        .font(.caption)
        .foregroundColor(.secondary)
      
      Text(project.projectTitle)
        .font(.title2)
      
      ProgressView(value: project.completionAmount)
        .accentColor(Color(project.projectColor))
    }
    .padding()
    .background(Color.secondarySystemGroupedBackground)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.2), radius: 5)
    .accessibilityElement(children: .ignore)
    .accessibilityLabel(project.label)
  }
}
