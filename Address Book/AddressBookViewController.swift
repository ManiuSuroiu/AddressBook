//
//  ViewController.swift
//  Address Book
//
//  Created by Maniu Suroiu on 25/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit
import CoreData

class AddressBookViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var contactsTableView: UITableView!
  @IBOutlet weak var addNewContact: UIButton!
  
  var managedContext: NSManagedObjectContext!
  
  /* Create an instance of NSFetchedResultsController to setup a fetch request - Lazy initialization - allocate it only when first used */
  lazy var fetchedResultsController: NSFetchedResultsController<Contact> = {
    
    /* Create a fetch request using the data model and set its entity */
    let fetchRequest = NSFetchRequest<Contact>()
    let entity = Contact.entity()
    fetchRequest.entity = entity
    
    /* Create a sort descriptor object to sort the objects (the names in the table view) alphabetically */
    let sortDescriptor = NSSortDescriptor(key: "fullName", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    /* The table view displays only a handful of objects at a time so the request fetches in batches of 20 objects (enough to populate the table view) to cut down on memory usage */
    fetchRequest.fetchBatchSize = 20
    
    /* Once the fetch request is set up, initialize a NSFetchedResultsController */
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: self.managedContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    
    /* Set the view controller as its delegate to listen to notifications */
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
  /* Explicitly set the delegate to nil when NSFetchedResultController is no longer needed - the view controller doesn't get notifications that were still pending */
  deinit {
    fetchedResultsController.delegate = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    performFetch()
  }
  
  // MARK: prepare(for:sender:) - do the last preparation before the transition betwwen the screens
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    /* If the user presses the "add new contact" button instantiate the AddNewContactViewController and pass it the managed object context var to handle the data entered by the user */
    if segue.identifier == "AddDetails" {
      
      let addNewContactViewController = segue.destination as! AddNewContactViewController
      addNewContactViewController.managedContext = managedContext
    
      /* If the user taps on a cell instantiate the ShowContactDetailsViewController and pass it the fetched data for the contact specified at that indexPath */
    } else if segue.identifier == "ShowDetails" {
      
      let showContactDetailsViewController = segue.destination as! ShowContactDetailsViewController
      if let indexPath = contactsTableView.indexPath(for: sender as! ContactTableViewCell) {
        showContactDetailsViewController.contactDetails = fetchedResultsController.object(at: indexPath)
      }
    }
  }
  
  /* Call performFetch() on fetchedResultsController to get the data from Core Data */
  func performFetch() {
    
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Could not fetch: \(error), description: \(error.userInfo)")
    }
  }
}

// MARK: UITableViewDataSource

extension AddressBookViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    /* The fetched results controller's sections property returns an array of NSFetchedResultsSectionInfo objects describing each section in the table view */
    guard let sections = fetchedResultsController.sections else {
      fatalError("No sections in fetchResultsController")
    }
    let sectionInfo = sections[section]
    /* numberOfObjects property contains the number of rows */
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
    let details = fetchedResultsController.object(at: indexPath) /* Ask the fetchedResultsController for the object at the requested index-path */
    cell.nameLabel.text! = details.fullName
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  /* Swipe-to-delete*/
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      /* Get the object at specified index-path and ask the managed context to delete it */
      let contactToRemove = fetchedResultsController.object(at: indexPath)
      managedContext.delete(contactToRemove)
    }
    
    /* Save the changes made */
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Saving error: \(error), description: \(error.userInfo)")
    }
  }
}

// MARK: UITableViewDelegate

extension AddressBookViewController: UITableViewDelegate {
  
  /* Deselct the cell when the user taps on it */
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: NSFetchedResultsControllerDelegate - through this delegate NSFetchedResultsController informs the AddressBookViewController that objects have been added, changed or deleted. In response the view controller should update the table

extension AddressBookViewController: NSFetchedResultsControllerDelegate {
  
  /* fetchResultsController is about to start */
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerWillChangeContent")
    contactsTableView.beginUpdates()
  }
  
  /* Notifies the view controller that a fetched object has been changed  - add, remove, update or move operation */
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
    switch type {
    
    case .insert:
      print("*** NSFetchedResultsChangeInsert (object)")
      contactsTableView.insertRows(at: [newIndexPath!], with: .fade)
    
    case .delete:
      print("*** NSFetchedResultsChangeDelete (object)")
      contactsTableView.deleteRows(at: [indexPath!], with: .fade)
    
    case .update:
      print("*** NSFetchedResultsChangeUpdate (object)")
      if let cell = contactsTableView.cellForRow(at: indexPath!) as? ContactTableViewCell {
        let contact = controller.object(at: indexPath!) as! Contact
        cell.nameLabel.text! = contact.fullName
      }
      
    case .move:
      print("*** NSFetchedResultsChangeMove (object)")
      contactsTableView.deleteRows(at: [indexPath!], with: .fade)
      contactsTableView.insertRows(at: [newIndexPath!], with: .fade)
    }
  }
  
  /* Notifies the view controller that a section has been added or removed */
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange sectionInfo: NSFetchedResultsSectionInfo,
                  atSectionIndex sectionIndex: Int,
                  for type: NSFetchedResultsChangeType) {
    
    switch type {
    
    case .insert:
      print("*** NSFetchedResultsChangeInsert (section)")
      contactsTableView.insertSections(IndexSet(integer: sectionIndex),
                               with: .fade)
    case .delete:
      print("*** NSFetchedResultsChangeDelete (section)")
      contactsTableView.deleteSections(IndexSet(integer: sectionIndex),
                               with: .fade)
    case .update:
      print("*** NSFetchedResultsChangeUpdate (section)")
    
    case .move:
      print("*** NSFetchedResultsChangeMove (section)")
    }
  }
  
  /* The fetchedResultsController has completed processing of one or more changes */
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("*** controllerDidChangeContent")
    contactsTableView.endUpdates()
  }
}










