//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Simon Shen on 1/14/22.
//

import Foundation

extension Project {
  static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
  
  
  var projectTitle: String {
    title ?? NSLocalizedString("New Project", comment: "Create a new project")
  }
  
  var projectDetail: String {
    detail ?? ""
  }
  
  var projectColor: String {
    color ?? "Light Blue"
  }
  
  var projectItems: [Item] {
    items?.allObjects as? [Item] ?? []
  }
  
  var projectItemsDefaultSorted: [Item] {
    projectItems.sorted { first, second in
      // true 则 first 在前 second 在後, 未完成在前，已完成在後
      if first.completed == false {
        if second.completed == true {
          return true
        }
      } else if first.completed {
        if second.completed == false {
          return false
        }
      }
      
      // both completed or incompleted，依优先级从高到低
      if first.priority > second.priority {
        return true
      } else if first.priority < second.priority {
        return false
      }
      
      // both completed/incompleted and with the same priority，依創建時間從过去到現在
      return first.itemCreationDate < second.itemCreationDate
    }
  }
  
  var completionAmount: Double {
    let originalItems = items?.allObjects as? [Item] ?? []
    guard originalItems.isEmpty == false else { return 0}
    
    let completedItems = originalItems.filter(\.completed)
    return Double(completedItems.count) / Double(originalItems.count)
  }
  
  static var example: Project {
    let controller = DataController(inMemory: true)
    let viewContext = controller.container.viewContext
    
    let project = Project(context: viewContext)
    project.title = "Example Project"
    project.detail = "This is an example project"
    project.closed = true
    project.creationDate = Date()
    
    return project
  }
  
  func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
    switch sortOrder {
      case .optimized:
        return projectItemsDefaultSorted
      case .title:
        return projectItems.sorted { $0.itemTitle < $1.itemTitle }
      case .creationDate:
        return projectItems.sorted(by: \Item.itemCreationDate)
    }
  }
  
  func projectItems(using sortDescriptor: NSSortDescriptor?) -> [Item] {
    guard let sortDescriptor = sortDescriptor else {
      return projectItemsDefaultSorted
    }
    return projectItems.sorted(by: sortDescriptor)
  }
}
