//
//  SimilarMovie+CoreDataProperties.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SimilarMovie {

    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var posterPath: String?
    @NSManaged var rating: String?
    @NSManaged var ratingCount: String?
    @NSManaged var overview: String?
    @NSManaged var released: String?
    @NSManaged var favoriteMovie: FavoriteMovie?

}
