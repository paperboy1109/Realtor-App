//
//  Home+CoreDataProperties.swift
//  Realtor-App
//
//  Created by Daniel J Janiak on 7/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Home {

    @NSManaged var price: NSNumber?
    @NSManaged var image: NSData?
    @NSManaged var sqft: NSNumber?
    @NSManaged var bed: NSNumber?
    @NSManaged var bath: NSNumber?
    @NSManaged var county: String?
    @NSManaged var category: Category?
    @NSManaged var location: Location?
    @NSManaged var status: Status?

}
