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
    
    var similarMovies = [TMDBMovie]()
    var posters = [UIImage?]()
    var posterPaths = [String?]()
    
    @IBOutlet weak var actors: UILabel!

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
        
        if let id = id {
            getSimilarMovies(Int(id)!)
        }
    }
    
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
       
        
        print(id)
        print(movie?.id)
        
        // get movie trailer
        if let movieId = id {
            TMDBClient.sharedInstance().getMovieVideos(movieId) { (result, error) -> Void in
                if let trailers = result {
                    self.trailerKey = trailers[0].trailerKey
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
        scrollView.contentSize.height = 1000
        
        if let overview = summary {
            movieSummary.text = overview
        }
        
        if let title = filmTitle {
            movieTitle.text = title
            moreTitle.text = title
        }
        
        if let runtime = movieRunTime {
            runTime.text = "\(runtime)"
        }
        
        if let release = releaseDate {
            releaseYear.text = release
        }
        
        if let image = posterImage {
            //poster.imageView?.image = image
            self.poster.setImage(image, forState: .Normal)
        }
    }
    

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addToWatchList(sender: AnyObject) {
        
    }
    
    @IBAction func trailer(sender: AnyObject) {
        /*let stringURL = "https://www.youtube.com/watch?v=\(trailerKey)"
        let url = NSURL(string: stringURL) */
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieTrailerViewController") as! MovieTrailerViewController
        controller.trailerKey = trailerKey
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SimilarMoviePosterCollectionViewCell
        
        print(self.posterPaths)
        if let poster = posters[indexPath.row] {
            cell.poster.image = poster
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let movie = similarMovies[indexPath.row]
    }
    
    func getSimilarMovies(movieId: Int) {
        TMDBClient.sharedInstance().getSimilarMovies(movieId) { (result, error) -> Void in
            if let movies = result {
                  //  self.similarMovies.reloadData()
                    var count = 0
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    for movie in movies {
                        if count == 6 {
                            break
                        }
                        
                        if let poster = movie.posterPath {
                            //self.posterPaths.append(poster)
                            self.similarMovies.append(movie)
                            self.downloadPoster(poster)
                        }
                        
                        count++
                    }
                    self.similarToMovies.reloadData()
                })
                    

                
            }
        }
    }
    
    func downloadPoster(posterImage: String?) {
        if let posterImage = posterImage {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[1], filePath: posterImage, completionHandler: { (imageData, error) -> Void in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.posters.append(image)
                        self.similarToMovies.reloadData()
                    })
                    
                    
                }
            })
        }
    }
}
