//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Simon Shen on 1/13/22.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
  @StateObject var dataController: DataController
  
  init() {
    let dataController = DataController()
    _dataController = StateObject(wrappedValue: dataController)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
  }
}