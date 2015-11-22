//
//  MovieDetailViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    
    var movieIds = [Int?](count: 3, repeatedValue: nil)
    var moviePosters = [Int]()
    var movies = [TMDBMovie]()
    
    var selectedMovie : TMDBMovie?
    
    @IBOutlet weak var posterContainer: UIView!
    @IBOutlet weak var ratings: CosmosView!
    @IBOutlet weak var movieTitle: UILabel!
    var currMovie : SimilarMovie?
    
    var likedMovies = [LikedMovie]()
    
    var movieIndex = 0
    
    var similarMovies = [SimilarMovie]()
    
    let moc = DataController().managedObjectContext
    var user : User?

    @IBOutlet weak var poster: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFromCoreData()
        
        movieIds = [17169, 54833, 43522]
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        posterContainer.addGestureRecognizer(gesture)
        posterContainer.userInteractionEnabled = true
    }
    
    func getFromCoreData() {
        let userFetch = NSFetchRequest(entityName: "User")
        
        do {
            let fetchedUser = try moc.executeFetchRequest(userFetch) as! [User]
            
            //fetchedUser.first?.mutableSetValueForKey("favofaf").addObject(<#T##object: AnyObject##AnyObject#>)
            if let user = fetchedUser.first {
                self.user = user
                getMoviesFromCoreData()
            }
            
        } catch {
            fatalError("could not retrive user data \(error)")
        }
    }
    
    func getMoviesFromCoreData() {
        let favMovies = user?.favoriteMovie?.allObjects as? [FavoriteMovie]
        for movie in favMovies!{
            let movies = movie.similarMovie?.allObjects as! [SimilarMovie]
            similarMovies += movies
        }
        movieTitle.text = similarMovies[movieIndex].title
        setMoviePoster(movieIndex)

        movieIndex++
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(view)
        let poster = gesture.view!
        
        // move the image
        poster.center = CGPoint(x: view.bounds.width / 2 + translation.x, y: view.bounds.height / 2 + translation.y)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if poster.center.x < 100 {
                removeMovie()
                self.setMoviePoster(movieIndex)
            }
            else if poster.center.x > view.bounds.width - 100 {
                //likedMovies.append(currMovie!)
                removeMovie()
                addLikedMovieToCoreData(currMovie!)
                self.setMoviePoster(movieIndex)
            }
            
            self.movieTitle.text = self.similarMovies[self.movieIndex].title
            var rating = self.similarMovies[self.movieIndex].rating!
            self.ratings.rating = Double(rating)!
            
            poster.center = CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2 )
            
        }
    }
    
    func addLikedMovieToCoreData(movie: SimilarMovie) {
        let likedMovie = NSEntityDescription.insertNewObjectForEntityForName("LikedMovie", inManagedObjectContext: moc) as! LikedMovie
        likedMovie.title = movie.title!
        likedMovie.id = movie.id!
        likedMovie.rating = movie.rating!
        likedMovie.ratingCount = movie.ratingCount!
        likedMovie.posterPath = movie.posterPath!
        
        user!.mutableSetValueForKey("likedMovie").addObject(likedMovie)
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save context: \(error)")
        }
    
    }

    func setMoviePoster(movInd: Int) {
        print(movInd)
        TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[4], filePath: similarMovies[movInd].posterPath!) { (imageData, error) -> Void in
            if let image = UIImage(data: imageData!) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.poster.setImage(image, forState: .Normal)
                    //self.currMovie = self.movies[movInd]
                    self.currMovie = self.similarMovies[movInd]
                    self.movieIndex += 1
                })
                
            }
        }
    }

    @IBAction func showLiked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LikedMoviesTableViewController") as! LikedMoviesTableViewController
            controller.movies = self.likedMovies
            controller.user = self.user
            controller.moc = self.moc
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @IBAction func showFavorites(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("FavoriteMoviesCollectionViewController") as! FavoriteMoviesCollectionViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @IBAction func showMore(sender: AnyObject) {
        if let id = currMovie?.id {
            getMovieDetails(id)
        }
        
    }
    
    func getMovieDetails(movieId: String) {
        let spinner : UIActivityIndicatorView = HelperFunctions.startSpinner(view)
        TMDBClient.sharedInstance().getMovieDetails(movieId) { (result, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                if let movies = result as? [TMDBMovie]? {
                    if let movie = movies![0] as? TMDBMovie {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            /* self.movieTitle.text = movie.title
                            self.releaseYear.text = movie.releaseDate
                            self.runtime.text = "\(movie.runtime!)"
                            self.summary.text = movie.overview
                            self.rating.rating = movie.rating */
                            self.selectedMovie?.id = movie.id
                            self.selectedMovie?.title = movie.title
                            self.selectedMovie?.rating = movie.rating
                            self.selectedMovie?.voteCount = movie.voteCount
                            self.selectedMovie?.releaseDate = movie.releaseDate
                            self.selectedMovie?.posterPath = movie.posterPath
                            
                            let navController = self.storyboard?.instantiateViewControllerWithIdentifier("MoreDetailsNav") as! UINavigationController
                            let controller = navController.topViewController as! MoreInfoViewController
                            
                            
                            
                            //let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MoreInfoViewController") as! MoreInfoViewController
                            print(movie.id)
                            controller.id = "\(movie.id!)"
                            controller.releaseDate = movie.releaseDate
                            controller.summary = movie.overview
                            controller.filmTitle = movie.title
                            controller.movieRunTime = "\(movie.runtime!)"
                            controller.posterImage = self.poster.imageView?.image
                            
                            HelperFunctions.stopSpinner(spinner)
                            self.presentViewController(navController, animated: true, completion: nil)
                            
                        })
                    }
                    
                }
            }
        }
    }
    
    @IBAction func dislike(sender: AnyObject) {
        removeMovie()
        setMovieData()
    }
    
    @IBAction func like(sender: AnyObject) {
        removeMovie()
        setMovieData()
        addLikedMovieToCoreData(currMovie!)
    }
    
    func setMovieData() {
        self.setMoviePoster(movieIndex)
        self.movieTitle.text = self.similarMovies[self.movieIndex].title
        let rating = self.similarMovies[self.movieIndex].rating!
        self.ratings.rating = Double(rating)!
    }
    
    func removeMovie() {
        let favMovies = user?.favoriteMovie?.allObjects as! [FavoriteMovie]
        
        for movie in favMovies {
            movie.mutableSetValueForKey("similarMovie").removeObject(currMovie!)
            do {
                try moc.save()
            } catch {
                fatalError("failure to save context: \(error)")
            }
        }
    }
}
