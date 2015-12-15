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
    
    var moviePosters = [Int]()
    var movies = [TMDBMovie]()
    
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var noMovies: UIView!
    var selectedMovie : TMDBMovie?
    
    @IBOutlet weak var editFavoritesBtn: UIButton!
    @IBOutlet weak var posterContainer: UIView!
    @IBOutlet weak var ratings: CosmosView!
    @IBOutlet weak var movieTitle: UILabel!
    var currMovie : SimilarMovie?
    
    var watchList = Set<String>()
    var passedList = Set<String>()
    
    var likedMovies = [LikedMovie]()
    
    var movieIndex = 0
    
    var similarMovies = [SimilarMovie]()
    
    let moc = DataController().managedObjectContext
    var user : User?
    
    var favoritesButton : UIBarButtonItem!
    var rewardsButton : UIBarButtonItem!

    @IBOutlet weak var poster: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HelperFunctions.styleButton(editFavoritesBtn)
        HelperFunctions.styleButton(noBtn)
        HelperFunctions.styleButton(yesBtn)
        
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")

        
        favoritesButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "showFavorites")
        
        rewardsButton = UIBarButtonItem(image: UIImage(named: "greenPrize"), style: UIBarButtonItemStyle.Plain, target: self, action: "showRewards")
        
        //self.navigationItem.leftBarButtonItems = [favoritesButton, rewardsButton]
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        posterContainer.addGestureRecognizer(gesture)
        posterContainer.userInteractionEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        print(similarMovies.count)
        if similarMovies.count > 0 {
            setMovieData()
        }
        else {
            getFromCoreData()
        }
    }
    
    func getFromCoreData() {
        let userFetch = NSFetchRequest(entityName: "User")
        
        do {
            let fetchedUser = try moc.executeFetchRequest(userFetch) as! [User]

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
        
        var simMovies = [SimilarMovie]()
        
        for movie in favMovies!{
            let movies = movie.similarMovie?.allObjects as! [SimilarMovie]
            simMovies += movies
        }
        
        let watchlistMovies = user!.likedMovie?.allObjects as! [LikedMovie]
        let passedMovies = user!.passedMovie?.allObjects as! [PassedMovie]
        
        for movie in watchlistMovies {
            if let id = movie.id {
                watchList.insert(id)
            }
        }
        
        for movie in passedMovies {
            if let id = movie.id {
                passedList.insert(id)
            }
        }
        
        for (index, movie) in simMovies.enumerate() {
            let movId = movie.id
            if let id = movId {
                if (!(watchList.contains(id) || passedList.contains(id))) {
                    print(movie.title)
                    similarMovies.append(simMovies[index])
                }
            }
        }
        
        if similarMovies.count > 0 {
            self.movieIndex = self.similarMovies.count-1
            setMovieData()
            self.movieIndex--
        }
        else {
            getMoreSimilarMovies()
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(view)
        let poster = gesture.view!
        
        // move the image
        poster.center = CGPoint(x: view.bounds.width / 2 + translation.x, y: view.bounds.height / 2 + translation.y)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if poster.center.x < 50 {
                passMovie()
            }
            else if poster.center.x > view.bounds.width - 50 {
                likeMovie()
            }
            
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
        
        HelperFunctions.addMovieToWatchlist(likedMovie, user: user, moc: moc) { (success) -> Void in
            if success {
                print("aded to watchlist")
            }
            else {
                print("could not add to watchilst")
            }
        }
    }
    
    func addPassedMovieToCoreData(movie: SimilarMovie?) {
        if let movie = movie {
            let passedMovie = NSEntityDescription.insertNewObjectForEntityForName("PassedMovie", inManagedObjectContext: moc) as! PassedMovie
            passedMovie.id = movie.id
            
            user?.mutableSetValueForKey("passedMovie").addObject(passedMovie)
            
            do {
                try moc.save()
            } catch {
                fatalError("failure to save context: \(error)")
            }
        }
    }

    func setMoviePoster(movInd: Int) {
        if movInd < self.similarMovies.count {
            print(movInd)
            print("movi count \(self.similarMovies.count)")
            if let poster = similarMovies[movInd].posterPath {
                TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[4], filePath: poster) { (imageData, error) -> Void in
                    if let image = UIImage(data: imageData!) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.poster.setImage(image, forState: .Normal)
                        })
                        if movInd < self.similarMovies.count {
                            self.currMovie = self.similarMovies[movInd]
                        }
                    }
                }
            }
            else {
                self.getMoreSimilarMovies()
            }
        }
        else {
            self.getMoreSimilarMovies()
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
    
    func showFavorites() {
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
                if let movies = result{
                    if (movies.count > 0) {
                        if let movie = movies[0] as? TMDBMovie {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.selectedMovie?.id = movie.id
                                self.selectedMovie?.title = movie.title
                                self.selectedMovie?.rating = movie.rating
                                self.selectedMovie?.voteCount = movie.voteCount
                                self.selectedMovie?.releaseDate = movie.releaseDate
                                self.selectedMovie?.posterPath = movie.posterPath
                                
                                let navController = self.storyboard?.instantiateViewControllerWithIdentifier("MoreDetailsNav") as! UINavigationController
                                let controller = navController.topViewController as! MoreInfoViewController
                                controller.id = "\(movie.id!)"
                                controller.releaseDate = movie.releaseDate
                                controller.summary = movie.overview
                                controller.filmTitle = movie.title
                                if let runtime = movie.runtime {
                                    controller.movieRunTime = "\(runtime)"
                                }
                                controller.posterImage = self.poster.imageView?.image
                                controller.genre = movie.genre
                                controller.moc = self.moc
                                controller.user = self.user
                                controller.rating = self.currMovie?.rating
                                controller.voteCount = self.currMovie?.ratingCount
                                controller.posterPath = self.currMovie?.posterPath
                                controller.recMovies = self.similarMovies
                                controller.movieDetailView = self
                                
                                HelperFunctions.stopSpinner(spinner)
                                self.presentViewController(navController, animated: true, completion: nil)
                                
                            })
                        }
                    }
                    
                }
            }
        }
    }
    
    func passMovie() {
        SessionM.sharedInstance().logAction("swipe_left")
        removeMovie()
        if similarMovies.count > 0 {
            setMovieData()
            addPassedMovieToCoreData(currMovie)
        }
        else {
            getMoreSimilarMovies()
        }
    }
    
    func likeMovie() {
        SessionM.sharedInstance().logAction("swipe_right")
        removeMovie()
        if similarMovies.count > 0 {
            setMovieData()
            addLikedMovieToCoreData(currMovie!)
        }
        else {
            getMoreSimilarMovies()
        }
    }
    
    @IBAction func dislike(sender: AnyObject) {
        passMovie()
    }
    
    @IBAction func like(sender: AnyObject) {
        likeMovie()
    }
    
    
    func setMovieData() {
        self.setMoviePoster(movieIndex)
        self.movieTitle.text = self.similarMovies[self.movieIndex].title
        let rating = self.similarMovies[self.movieIndex].rating!
        self.ratings.rating = Double(rating)!
    }
    
    func removeMovie() {
        similarMovies.popLast()
        movieIndex = similarMovies.count - 1
        
        if similarMovies.count < 1 {
            
            
        }
    }
    
    func getMoreSimilarMovies() {
        movieIndex = 0
        let spinner = HelperFunctions.startSpinner(self.view)
        let favMovies = user?.favoriteMovie?.allObjects as! [FavoriteMovie]
        
        if (favMovies.count < 1) {
            self.noMovies.hidden = false
        }
        else {
            self.noMovies.hidden = true
        }
        
        for movie in favMovies {
            movie.mutableSetValueForKey("similarMovie").removeAllObjects()
            do {
                try moc.save()
            } catch {
                fatalError("failure to save context: \(error)")
            }
        }
        
        
        for movie in favMovies {
            HelperFunctions.getSimilarMovies(movie, user: user!, moc: moc) { (result, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.noMovies.hidden = false
                    })
                }
                else {
                    self.getMoviesFromCoreData()

                }
            }
        }
        
        HelperFunctions.stopSpinner(spinner)
    }
}
