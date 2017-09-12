//
//  ViewController.swift
//  Address Book
//
//  Created by Maniu Suroiu on 25/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit
import CoreData

class AddressBookViewController: UIViewController, ContactDetailsViewControllerDelegate {
  
  // MARK: Outlets
  @IBOutlet weak var contactsTableView: UITableView!
  @IBOutlet weak var addNewContact: UIButton!
  
  /* An instance of the data model to hold the details of contacts entered by the user in ContactDetailsViewController */
  var contactDetails: [Details] = []
  var managedContext: NSManagedObjectContext!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /* Set a zero height table footer so the table view doesn't display extra cells */
    contactsTableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    /* Hide the table view if there are no contacts to display (the array is empty) */
    contactsTableView.isHidden = contactDetails.isEmpty
  }
  
  // MARK: prepare(for:sender:) - do the last preparation before the transition betwwen the screens
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    /* If the user presses the "add new contact" button instantiate the AddNewContactViewController and tell it that this view controller is now its delegate */
    if segue.identifier == "AddDetails" {
      
      let addNewContactViewController = segue.destination as! AddNewContactViewController
      addNewContactViewController.delegate = self
    
      /* If the user taps on a cell instantiate the ShowContactDetailsViewController and pass it the details data for the contact specified at that indexPath */
    } else if segue.identifier == "ShowDetails" {
      
      let showContactDetailsViewController = segue.destination as! ShowContactDetailsViewController
      if let indexPath = contactsTableView.indexPath(for: sender as! ContactTableViewCell) {
        showContactDetailsViewController.details = contactDetails[indexPath.row]
      }
    }
  }
  
  /* Implement the method from the protocol - add the new Details object to the data model and table view */
  func addNewContactViewController(_ controller: AddNewContactViewController, didFinishEditing details: Details) {
    let newRowIndex = contactDetails.count
    contactDetails.append(details)
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    contactsTableView.insertRows(at: [indexPath], with: .automatic)
    dismiss(animated: true, completion: nil)
  }
}

// MARK: UITableViewDataSource

extension AddressBookViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactDetails.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
    let details = contactDetails[indexPath.row]
    cell.nameLabel.text! = details.description
    return cell
  }
  
  /* Swipe-to-delete*/
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      contactDetails.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
}

extension AddressBookViewController: UITableViewDelegate {
  
  /* Deselct the cell when the user taps on it */
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}










