//
//  User+CoreDataProperties.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var userName: String?
    @NSManaged var userID: NSNumber?
    @NSManaged var sessionID: String?
    @NSManaged var favoriteMovies: NSSet?

}
