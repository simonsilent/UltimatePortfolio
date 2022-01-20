//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Simon Shen on 1/13/22.
//

import SwiftUI

struct ProjectsView: View {
  static let openTag: String? = "Open"
  static let closedTag: String? = "Closed"
  
  @EnvironmentObject var dataController: DataController
  @Environment(\.managedObjectContext) var managedObjectContext
  
  @State private var showingSortOrder = false
  @State private var sortOrder = Item.SortOrder.optimized
  @State private var sortDescriptor: NSSortDescriptor?
  
  let showClosedProjects: Bool
  
  let projects: FetchRequest<Project>
  
  init(showClosedProjects: Bool) {
    self.showClosedProjects = showClosedProjects
    
    projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
    ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
  }
  
  var projectsList: some View {
    List {
      ForEach(projects.wrappedValue) { project in
        Section(header: ProjectHeaderView(project: project)) {
          ForEach(project.projectItems(using: sortOrder)) { item in
            ItemRowView(project: project, item: item)
          }
          .onDelete { offsets in
            delete(offsets, from: project)
          }
          
          if showClosedProjects == false {
            Button {
              addItem(to: project)
            } label: {
              Label("Add New Item", systemImage: "plus")
            }
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
  
  var addProjectToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      if showClosedProjects == false {
        Button(action: addProject) {
          // in iOS 14.3 VoiceOver has a glitch that reads the label
          // "Add Project" as "Add" no matter what accessibility label
          // we give this toolbar button when using a Label.
          // As a result, when VoiceOver is running, we use a text view
          // for the button instead, forcing a correct reading without
          // losing the original layout.
          if UIAccessibility.isVoiceOverRunning {
            Text("Add Project")
          } else {
            Label("Add Project", systemImage: "plus")
          }
        }
      }
    }
  }
  
  var sortOrderToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        showingSortOrder.toggle()
      } label: {
        Label("Sort", systemImage: "arrow.up.arrow.down")
      }
    }
  }
  
  var body: some View {
    NavigationView {
      Group {
        if projects.wrappedValue.isEmpty {
          Text("There's nothing here right now")
            .foregroundColor(.secondary)
        } else {
          projectsList
        }
      }
      .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
      .toolbar {
        addProjectToolbarItem
        sortOrderToolbarItem
      }
      .actionSheet(isPresented: $showingSortOrder) {
        ActionSheet(title: Text("Sort items"), message: nil, buttons: [
          // 同時使用兩種排序實現方式
          .default(Text("Optimized")) {
            sortOrder = .optimized
            sortDescriptor = nil
          },
          .default(Text("Creation Date")) {
            sortOrder = .creationDate
            sortDescriptor = NSSortDescriptor(keyPath: \Item.creationDate, ascending: true)
          },
          .default(Text("Title")) {
            sortOrder = .title
            sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true)
          }
        ])
      }
      
      SelectSomethingView()
    }
  }
  
  func addProject() {
    withAnimation {
      let project = Project(context: managedObjectContext)
      project.closed = false
      project.creationDate = Date()
      dataController.save()
    }
  }
  
  func addItem(to project: Project) {
    withAnimation {
      let item = Item(context: managedObjectContext)
      item.project = project
      item.creationDate = Date()
      dataController.save()
    }
  }
  
  func delete(_ offsets: IndexSet, from project: Project) {
    let allItems = project.projectItems(using: sortOrder)
    
    for offset in offsets {
      let item = allItems[offset]
      dataController.delete(item)
    }
    dataController.save()
  }
}

struct ProjectsView_Previews: PreviewProvider {
  static var dataController = DataController.preview
  
  static var previews: some View {
    ProjectsView(showClosedProjects: false)
      .environment(\.managedObjectContext, dataController.container.viewContext)
      .environmentObject(dataController)
  }
}
