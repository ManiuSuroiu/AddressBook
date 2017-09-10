//
//  ContactDetailsViewController.swift
//  Address Book
//
//  Created by Maniu Suroiu on 01/07/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UITableViewController, UITextFieldDelegate {
  
  // MARK: Outlets
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailAddressTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView() /* Set a zero height table footer so the table view doesn't display extra cells */
  }
  
  // MARK: UITextFieldDelegate
  
  /* Set a clear button on the right edge of the text fields when the user starts editing */
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.clearButtonMode = .whileEditing
  }
  
  /* Dismiss the keyboard once the user finishes editing and presses return */
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // MARK: UITableViewDelegate
  
  /* Disable selections for all the rows in the static table view */
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}













