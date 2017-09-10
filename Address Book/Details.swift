//
//  Details.swift
//  Address Book
//
//  Created by Maniu Suroiu on 01/07/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit

class Details {
  var firstName: String
  var lastName: String
  var emailAddress: String
  var phoneNumberString: String
  var address: String
    
  init(firstName: String, lastName: String, emailAddress: String, phoneNumberString: String, address: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.emailAddress = emailAddress
    self.phoneNumberString = phoneNumberString
    self.address = address
  }
}

extension Details: CustomStringConvertible {
  
  /* A string containing the name of the contact necessary to populate the contactsTableView */
  var description: String {
    return [firstName, lastName].joined(separator: " ")
  }

}












