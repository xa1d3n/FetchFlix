//
//  MoreInfoViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MediaPlayer

class MoreInfoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var movie : TMDBMovie?
    var trailerKey: String?
    var id: String?
    var filmTitle: String?
    var releaseDate: String?
    var summary: String?
    var posterPath: String?
    var movieRunTime : String?
    var posterImage : UIImage?
    var genre: String?
    var moc = DataController().managedObjectContext
    var user : User?
    var rating : String?
    var voteCount : String?
    
    @IBOutlet weak var removeWatchlist: UIButton!
    weak var movieDetailView : MovieDetailViewController?
    
    @IBOutlet weak var watchlistBtn: UIButton!
    @IBOutlet weak var trailerBtn: UIButton!
    var similarMovies = [TMDBMovie]()
    var recMovies = [SimilarMovie]()
    var posters = [UIImage?]()
    var posterPaths = [String?]()
    
    @IBOutlet weak var actors: UILabel!

    @IBOutlet weak var genreIcon: UIImageView!
    @IBOutlet weak var similarToMovies: UICollectionView!
    @IBOutlet weak var movieSummary: UITextView!

    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var poster: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var moreTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style buttons
        HelperFunctions.styleButton(trailerBtn)
        HelperFunctions.styleButton(watchlistBtn)
        HelperFunctions.styleButton(removeWatchlist)
        watchlistBtn.hidden = true
        
        if let id = id {
            getMovieInfo(id)
            checkMovieState(id)
            getSimilarMovies(Int(id)!)
        }
        
    }
    
    // check wheter movies is already in watchlist and set icon accordingly
    func checkMovieState(id: String?) {
        if let id = id {
            TMDBClient.sharedInstance().getMovieStates(id) { (result, error) -> Void in
                if (result != nil) {
                    if let isWatched = result![0].watchlist {
                        if isWatched == true {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.removeWatchlist.hidden = false
                            })
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.watchlistBtn.hidden = false
                            })
                        }
                    }
                }
            }
        }
    }
    
    // get more information about movie
    func getMovieInfo(id: String?) {
        TMDBClient.sharedInstance().getMovieDetails(id!) { (result, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                if let movies = result{
                    if (movies.count > 0) {
                        if let movie = movies[0] as? TMDBMovie {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if let time = movie.runtime {
                                    self.runTime.text = "\(time)m"
                                }
                                if let genre = movie.genre {
                                    self.getGenre(genre)
                                }
                                
                            })
                        }
                    }
                    
                }
            }
        }

    }
    
    // retrive list of actors
    func getActors(id: String?) {
        if let id = id {
            TMDBClient.sharedInstance().getMovieCredits(id) { (result, error) -> Void in
                if error != nil {
                    print(error)
                }
                else {
                    if let actors = result {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var i = 0
                        for actor in actors {
                            if i == 3 {
                                break
                            }
                            
                            if var name = actor.actorName {
                                
                                    if i == 1 {
                                        name = ", \(name), "
                                    }
                                    self.actors.text?.appendContentsOf(name)
                                
                                i++
                            }
                            
                            
                        }
                            
                        })
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        getActors(id)
        
        // get movie trailer
        if let movieId = id {
            TMDBClient.sharedInstance().getMovieVideos(movieId) { (result, error) -> Void in
                if let trailers = result {
                    if trailers.count > 0 {
                        if let trailerKey = trailers[0].trailerKey {
                            self.trailerKey = trailerKey
                        }
                    }
                }
            }
        }
        
        if let overview = summary {
            movieSummary.text = overview
        }
        
        if let title = filmTitle {
            movieTitle.text = title
            moreTitle.text = title
        }
        
        if let runtime = movieRunTime {
            runTime.text = "\(runtime)m"
        }
        
        if let release = releaseDate {
            releaseYear.text = (release as NSString).substringToIndex(4)
        }
        
        if let image = posterImage {
            //poster.imageView?.image = image
            self.poster.setImage(image, forState: .Normal)
        }

        if let genre = genre {
            getGenre(genre)
        }
    }
    
    // get movie genre and set genre icon accordingly
    func getGenre(genre: String) {
        switch genre {
        case Genre.Action.rawValue:
            genreIcon.image = UIImage(named: Genre.Action.rawValue)
        case Genre.Adventure.rawValue:
            genreIcon.image = UIImage(named: Genre.Adventure.rawValue)
        case Genre.Animation.rawValue:
            genreIcon.image = UIImage(named: Genre.Animation.rawValue)
        case Genre.Comedy.rawValue:
            genreIcon.image = UIImage(named: Genre.Comedy.rawValue)
        case Genre.Crime.rawValue:
            genreIcon.image = UIImage(named: Genre.Crime.rawValue)
        case Genre.Documentary.rawValue:
            genreIcon.image = UIImage(named: Genre.Documentary.rawValue)
        case Genre.Drama.rawValue:
            genreIcon.image = UIImage(named: Genre.Drama.rawValue)
        case Genre.Family.rawValue:
            genreIcon.image = UIImage(named: Genre.Family.rawValue)
        case Genre.Fantasy.rawValue:
            genreIcon.image = UIImage(named: Genre.Fantasy.rawValue)
        case Genre.Foreign.rawValue:
            genreIcon.image = UIImage(named: Genre.Foreign.rawValue)
        case Genre.History.rawValue:
            genreIcon.image = UIImage(named: Genre.History.rawValue)
        case Genre.Horror.rawValue:
            genreIcon.image = UIImage(named: Genre.Horror.rawValue)
        case Genre.Music.rawValue:
            genreIcon.image = UIImage(named: Genre.Music.rawValue)
        case Genre.Mystery.rawValue:
            genreIcon.image = UIImage(named: Genre.Mystery.rawValue)
        case Genre.Romance.rawValue:
            genreIcon.image = UIImage(named: Genre.Romance.rawValue)
        case Genre.ScienceFiction.rawValue:
            genreIcon.image = UIImage(named: Genre.ScienceFiction.rawValue)
        case Genre.TVMovie.rawValue:
            genreIcon.image = UIImage(named: Genre.TVMovie.rawValue)
        case Genre.Thriller.rawValue:
            genreIcon.image = UIImage(named: Genre.Thriller.rawValue)
        case Genre.War.rawValue:
            genreIcon.image = UIImage(named: Genre.War.rawValue)
        case Genre.Western.rawValue:
            genreIcon.image = UIImage(named: Genre.Western.rawValue)
        default:
            genreIcon.image = UIImage(named: "Question")
        }
    }
    
    // close the view
    @IBAction func close(sender: AnyObject) {
        movieDetailView?.similarMovies = recMovies
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // handle add to watchlist button press
    @IBAction func addToWatchList(sender: AnyObject) {
        let likedMovie = NSEntityDescription.insertNewObjectForEntityForName("LikedMovie", inManagedObjectContext: moc) as! LikedMovie
        likedMovie.title = filmTitle
        likedMovie.id = id
        likedMovie.rating = rating
        likedMovie.ratingCount = voteCount
        likedMovie.posterPath = posterPath
        HelperFunctions.addMovieToWatchlist(likedMovie, user: user, moc: moc) { (success) -> Void in
            if success {
                print("aded to watchlist")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.watchlistBtn.hidden = true
                    self.removeWatchlist.hidden = false
                })
            }
            else {
                print("could not add to watchilst")
            }
        }
    }
    
    // handle remove from watchlist button press
    @IBAction func removeFromWatchlist(sender: AnyObject) {
        HelperFunctions.removeMovieFromWatchlist(id, user: user, moc: moc) { (success) -> Void in
            if success {
                print("deleted from watchlist")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.watchlistBtn.hidden = false
                    self.removeWatchlist.hidden = true
                })
            }
            else {
                print("coudl not remove from watchilst")
            }
        }
    }
    
    // handle trailer button press
    @IBAction func trailer(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieTrailerViewController") as! MovieTrailerViewController
        controller.trailerKey = trailerKey
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    // set movie posters
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SimilarMoviePosterCollectionViewCell
        
        if let poster = posters[indexPath.row] {
            cell.poster.image = poster
        }
        
        return cell
    }
    
    // handle poster click
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MoreInfoViewController") as! MoreInfoViewController
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let selectedMovie = self.similarMovies[indexPath.row]
            controller.id = "\(selectedMovie.id!)"
            controller.releaseDate = selectedMovie.releaseDate
            controller.summary = selectedMovie.overview
            controller.genre = selectedMovie.genre
            controller.filmTitle = selectedMovie.title
            controller.posterImage = self.posters[indexPath.row]
            if let rating = selectedMovie.rating {
                controller.rating = "\(rating)"
            }
            if let voteCount = selectedMovie.voteCount {
                controller.voteCount = "\(voteCount)"
            }
            controller.posterPath = selectedMovie.posterPath
            controller.user = self.user
            controller.moc = self.moc
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
    
    // get lis of similar movies
    func getSimilarMovies(movieId: Int) {
        TMDBClient.sharedInstance().getSimilarMovies(movieId, page: 1) { (result, error) -> Void in
            if let movies = result {
                  //  self.similarMovies.reloadData()
                    var count = 0
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    for movie in movies {
                        if count == 6 {
                            break
                        }
                        
                        if let poster = movie.posterPath {
                            self.downloadPoster(poster, movie: movie)
                        }
                        
                        count++
                    }
                    self.similarToMovies.reloadData()
                })
            }
        }
    }
    
    // get poster images
    func downloadPoster(posterImage: String?, movie: TMDBMovie) {
        if let posterImage = posterImage {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[1], filePath: posterImage, completionHandler: { (imageData, error) -> Void in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.posters.append(image)
                        self.similarMovies.append(movie)
                        self.similarToMovies.reloadData()
                    })
                }
            })
        }
    }
    
    // handle share button click
    @IBAction func share(sender: AnyObject) {
        let text = "Check out \(filmTitle!) on TMDb https://www.themoviedb.org/movie/\(id!)"
        let movieImage = posterImage
        let controller = UIActivityViewController(activityItems: [text, movieImage!], applicationActivities: nil)
        // present the controller
        
        self.presentViewController(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                SessionM.sharedInstance().logAction("share_movie")
            }
        }
    }

}
