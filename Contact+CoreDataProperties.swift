//
//  Contact+CoreDataProperties.swift
//  Address Book
//
//  Created by wehiremac on 12/09/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var fullName: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var emailAddress: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var address: String

}
