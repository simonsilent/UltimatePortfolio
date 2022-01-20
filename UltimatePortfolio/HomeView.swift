//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Simon Shen on 1/13/22.
//

import CoreData
import SwiftUI

struct HomeView: View {
  static let tag: String? = "Home"
  @EnvironmentObject var dataController: DataController
  
  @FetchRequest(
    entity: Project.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
    predicate: NSPredicate(format: "closed = false")
  ) var projects: FetchedResults<Project>
  
  let items: FetchRequest<Item>
  
  var projectRows: [GridItem] {
    [GridItem(.fixed(100))]
  }
  
  init() {
    // construct a fetch request to show the 10 high priority,
    // incomplete items from open projects.
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    let incompletedPred = NSPredicate(format: "completed = false")
    let openProjPred = NSPredicate(format: "project.closed = false")
    let compoundPred = NSCompoundPredicate(type: .and, subpredicates: [incompletedPred, openProjPred])
    request.predicate = compoundPred
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \Item.priority, ascending: false)
    ]
    request.fetchLimit = 10
    
    items = FetchRequest(fetchRequest: request)
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: projectRows) {
              ForEach(projects, content: ProjectSummaryView.init)
            }
            .padding([.horizontal, .top])
            .fixedSize(horizontal: false, vertical: true) // for iOS 14, fixed in iOS 15
          }
          
          VStack(alignment: .leading) {
            ItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
            ItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
          }
          .padding(.horizontal)
        }
      }
      .background(Color.systemGroupedBackground.ignoresSafeArea())
      .navigationTitle("Home")
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}

//Button("Add Data") {
//  dataController.deleteAll()
//  try? dataController.createSampleData()
//  }
