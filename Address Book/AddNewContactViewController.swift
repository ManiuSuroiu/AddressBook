//
//  AddNewContactViewController.swift
//  Address Book
//
//  Created by Maniu Suroiu on 28/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit

/* Define the delegate protocol */
protocol ContactDetailsViewControllerDelegate: class {
  func addNewContactViewController(_ controller: AddNewContactViewController, didFinishEditing details: Details)
}

class AddNewContactViewController: UIViewController {

  @IBOutlet weak var saveButton: UIButton!
  
  /* Optional variable to be able to refer to the delegate */
  weak var delegate: ContactDetailsViewControllerDelegate?
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func save() {
    
    /* Get a reference to the table view controller embedded in the view container */
    let vc = self.childViewControllers[0] as! ContactDetailsViewController
    
    /* Get the values entered by the user in the text fields. Do not allow the screen to be dismissed unless the firstName and lastName have values */
    guard let firstName = vc.firstNameTextField.text,
      let lastName = vc.lastNameTextField.text,
      let emailAddress = vc.emailAddressTextField.text,
      let phoneNumber = vc.phoneNumberTextField.text,
      let address = vc.addressTextField.text,
      firstName != "" || lastName != "" else {
      return
    }
    
    /* Instantiate a Details object with the values entered by the user */
    let details = Details(firstName: firstName, lastName: lastName, emailAddress: emailAddress, phoneNumberString: phoneNumber, address: address)
        
    print("\(details)")
    
    /* Pass the object back to delegate */
    delegate?.addNewContactViewController(self, didFinishEditing: details)
    
    /* Pops the view controller and returns back to AddressBookViewController */
    self.navigationController?.popToRootViewController(animated: true)
  }
}






















