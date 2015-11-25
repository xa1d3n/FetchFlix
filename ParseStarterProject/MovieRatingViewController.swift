//
//  MovieRatingViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreData

class MovieRatingViewController: UIViewController {

    var movie : LikedMovie?
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var ratings: CosmosView!
    
    var moc : NSManagedObjectContext?
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        self.title = "Watchlist"
        
        ratings.didTouchCosmos = touchedTheStar
        
        if let posterPath = movie?.posterPath {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[3], filePath: posterPath) { (imageData, error) -> Void in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.poster.image = image
                    })
                }
            }
        }
        
        if let movie = movie {
            if let yourRating = movie.yourRating {
                ratings.rating = Double(yourRating)!
                ratings.colorFilled = UIColor.yellowColor()
            }
            else if let rating = Double((movie.rating)!) {
                ratings.rating = rating
            }
            
            if let voteCount = movie.ratingCount {
                ratings.text = voteCount
            }
            
            if let title = movie.title {
                self.title = title
            }
        }
        
    }
    
    func touchedTheStar(rating: Double) {
        ratings.colorFilled = UIColor.yellowColor()
        saveRating(rating)
        if let id = movie?.id {
            TMDBClient.sharedInstance().rateMovie("\(id)", rating: rating) { (result, error) -> Void in
                if error != nil {
                    print(error)
                }
                else {
                    print(result)
                }
            }
        }
        
    }
    
    func saveRating(rating: Double) {
        var likedMovies = user?.likedMovie?.allObjects as! [LikedMovie]
        
        for likedMovie in likedMovies{
            if let id = movie!.id {
                if id == likedMovie.id {
                    likedMovie.setValue("\(rating)", forKey: "yourRating")
                    do {
                        try moc!.save()
                    } catch {
                        fatalError("failure to save context: \(error)")
                    }
                    break
                }

            }
        }
    }

}
