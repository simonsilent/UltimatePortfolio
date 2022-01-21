//
//  ProjectsViewModel.swift
//  UltimatePortfolio
//
//  Created by Simon Shen on 1/21/22.
//

import Foundation
import CoreData

extension ProjectsView {
  class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    let dataController: DataController
    
    var sortOrder = Item.SortOrder.optimized
    var sortDescriptor: NSSortDescriptor?
    
    let showClosedProjects: Bool
    
    private let projectsController: NSFetchedResultsController<Project>
    @Published var projects = [Project]()
    
    init(dataController: DataController, showClosedProjects: Bool) {
      self.dataController = dataController
      self.showClosedProjects = showClosedProjects
      
//      projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
//        NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
//      ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
      // 1. create a fetch request
      let request: NSFetchRequest<Project> = Project.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
      request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)
      // 2. create a fetched results controller
      projectsController = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: dataController.container.viewContext,
        sectionNameKeyPath: nil,
        cacheName: nil
      )
      // 3. set self as delegate, need to conform NSFetchedResultsDelegate
      // which requires self to conform to NSObject
      // which requires super.init()
      super.init()
      projectsController.delegate = self
      // 4. run the fetch request, assign the results into our array
      do {
        try projectsController.performFetch()
        projects = projectsController.fetchedObjects ?? []
      } catch {
        print("Failed to fetch our projects.")
      }
      // 5. get notified when data changed, see delegate method
      // down at the bottom of this page.
    }
    
    func addProject() {
      let project = Project(context: dataController.container.viewContext)
      project.closed = false
      project.creationDate = Date()
      dataController.save()
    }
    
    func addItem(to project: Project) {
      let item = Item(context: dataController.container.viewContext)
      item.project = project
      item.creationDate = Date()
      dataController.save()
    }
    
    func delete(_ offsets: IndexSet, from project: Project) {
      let allItems = project.projectItems(using: sortOrder)
      
      for offset in offsets {
        let item = allItems[offset]
        dataController.delete(item)
      }
      dataController.save()
    }
    
    // NSFetchedResultsController delegate method
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      if let newProjects = controller.fetchedObjects as? [Project] {
        projects = newProjects
      }
    }
  }
}
