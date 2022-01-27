//
//  ProjectTests.swift
//  UltimatePortfolioTests
//
//  Created by Simon Shen on 1/27/22.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

class ProjectTests: BaseTestCase {
  func testCreatingProjectsAndItems() {
    let targetCount = 10
    
    for _ in 0..<targetCount {
      let project = Project(context: moc)
      
      for _ in 0..<targetCount {
        let item = Item(context: moc)
        item.project = project
      }
    }
    
    XCTAssertEqual(
      dataController.count(for: Project.fetchRequest()),
      targetCount
    )
    XCTAssertEqual(
      dataController.count(for: Item.fetchRequest()),
      targetCount * targetCount
    )
  }

  func testDeletingProjectCascadeDeleteItems() throws {
    try dataController.createSampleData()
    
    let request = NSFetchRequest<Project>(entityName: "Project")
    let projects = try moc.fetch(request)
    
    dataController.delete(projects[0])
    
    XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
    XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
  }
}
