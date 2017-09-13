//
//  ShowContactDetailsViewController.swift
//  Address Book
//
//  Created by Maniu Suroiu on 09/09/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit

class ShowContactDetailsViewController: UITableViewController {
  
  // MARK: Outlets
  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var lastNameLabel: UILabel!
  @IBOutlet weak var emailAddressLabel: UILabel!
  @IBOutlet weak var phoneNumberLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  var contactDetails: Contact!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView() /* Set a zero height table footer so the table view doesn't display extra cells */
    updateUI()
  }
  
  func updateUI() {
    firstNameLabel.text! = contactDetails.firstName
    navigationItem.title = firstNameLabel.text! /* Set the title of the navigation bar to the first name of the contact */
    lastNameLabel.text! = contactDetails.lastName
    emailAddressLabel.text! = contactDetails.emailAddress
    phoneNumberLabel.text! = contactDetails.phoneNumber
    addressLabel.text! = contactDetails.address
  }
  
  // MARK: UITableViewDelegate
  
  /* Configure the height of a cell at a specified location */
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    /* Identify ta Address table view cell */
    if indexPath.section == 0 && indexPath.row == 4 {
      /* Display a regular height if there's no address in the label */
      if addressLabel.text!.isEmpty {
        return 44
      }
      
      /* Set the width of the label to about half the width of the screen so it makes the label multiline using word wrapping (set in IB). Make its height 1000 points to ensure there will be enough room no matter how long the address is */
      addressLabel.frame.size = CGSize(width: view.bounds.size.width - 180,
                                       height: 1000)
      
      /* Resize the label to fit its content */
      addressLabel.sizeToFit()
      /* Give the label a margin of 12 points to align it with the other labels */
      addressLabel.frame.origin.x = 12
      /* calculate the height of the cell by using the height of the label. Give it a 20 points margin (10 for top, 10 for bottom) */
      return addressLabel.frame.size.height + 20
    
    } else {
      return 44 /* The regular height for a cell */
    }
  }
  
  /* Disable selections for all the rows in the static table view */
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}













