//
//  CoreDataStack.swift
//  Address Book
//
//  Created by wehiremac on 12/09/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  private let modelName: String
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  /* Lazy instantiation of a persistent container - which encapsulates all four Core Data classes together */
  private lazy var storeContainer: NSPersistentContainer = {
    /* Initialize a persistent container and pass it the name of the data model */
    let container = NSPersistentContainer(name: self.modelName)
    /* Load the persistent stores on the container to complete the setup of Core Data Stack */
    container.loadPersistentStores {
      (storeDescription, error) in
      
      if let error = error as NSError? {
        print("Unresolved error: \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  /* The only accessible part of CoreDataStack - the only entry point required to access the rest of the stack */
  lazy var managedConetxt: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
  
  /* Convenience method to save the stack's managed context and handle errors */
  func saveContext() {
    guard managedConetxt.hasChanges else { return }
    
    do {
      try managedConetxt.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}










