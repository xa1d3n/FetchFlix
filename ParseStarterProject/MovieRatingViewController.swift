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
    
    var favoriteButton : UIBarButtonItem!
    var infoButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            checkMovieState(movie.id)
        }
        // Do any additional setup after loading the view.
        
        self.title = "Watchlist"
        
        favoriteButton = UIBarButtonItem(image: UIImage(named: "favorite"), style: UIBarButtonItemStyle.Plain, target: self, action: "addFavorite")
        infoButton = UIBarButtonItem(image: UIImage(named: "info"), style: UIBarButtonItemStyle.Plain, target: self, action: "info")
        
        self.navigationItem.rightBarButtonItems = [infoButton, favoriteButton]
        
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
    
    func favorite() {
        
    }
    
    func info() {
        let spinner : UIActivityIndicatorView = HelperFunctions.startSpinner(view)
        TMDBClient.sharedInstance().getMovieDetails((movie?.id)!) { (result, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                if let movies = result{
                    if (movies.count > 0) {
                        if let movie = movies[0] as? TMDBMovie {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let navController = self.storyboard?.instantiateViewControllerWithIdentifier("MoreDetailsNav") as! UINavigationController
                                let controller = navController.topViewController as! MoreInfoViewController
                                controller.id = "\(movie.id!)"
                                controller.releaseDate = movie.releaseDate
                                controller.summary = movie.overview
                                controller.filmTitle = movie.title
                                controller.movieRunTime = "\(movie.runtime!)"
                                controller.posterImage = self.poster.image
                                controller.genre = movie.genre
                                controller.user = self.user
                                controller.moc = self.moc!
                                
                                HelperFunctions.stopSpinner(spinner)
                                self.presentViewController(navController, animated: true, completion: nil)
                                
                            })
                        }
                    }
                    
                }
            }
        }

    }
    
    func addFavorite() {
        favoriteButton = UIBarButtonItem(image: UIImage(named: "favFilled"), style: UIBarButtonItemStyle.Plain, target: self, action: "addFavorite")
        self.navigationItem.rightBarButtonItems = [infoButton, favoriteButton]
    }
    
    func checkMovieState(id: String?) {
        if let id = id {
            TMDBClient.sharedInstance().getMovieStates(id) { (result, error) -> Void in
                if (result != nil) {
                    if let isWatched = result![0].favorited {
                        if isWatched == true {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                          //      self.removeWatchlist.hidden = false
                            })
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                           //     self.watchlistBtn.hidden = false
                            })
                        }
                    }
                }
            }
        }
    }
    
    func touchedTheStar(rating: Double) {
        ratings.colorFilled = UIColor.yellowColor()
        SessionM.sharedInstance().logAction("rate_action")
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
        let likedMovies = user?.likedMovie?.allObjects as! [LikedMovie]
        
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
