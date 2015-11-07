//
//  MovieDetailViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieIds = [Int?](count: 3, repeatedValue: nil)
    var moviePosters = [Int]()
    var movies = [TMDBMovie]()
    
    @IBOutlet weak var ratings: CosmosView!
    @IBOutlet weak var movieTitle: UILabel!
    var currMovie : TMDBMovie?
    
    var likedMovies = [TMDBMovie]()
    
    var movieIndex = 0

    @IBOutlet weak var poster: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // pageControl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        
        movieIds = [17169, 54833, 43522]
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.setMoviePoster(self.movieIndex)
            self.movieTitle.text = self.movies[self.movieIndex].title
            self.ratings.rating = self.movies[self.movieIndex].rating!
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        poster.addGestureRecognizer(gesture)
        poster.userInteractionEnabled = true
        

      /*  TMDBClient.sharedInstance().getMovieImages("550") { (result, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
                if let posters = result as? [TMDBImages]? {
                    for poster in posters! {
                        TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[2f], filePath: poster.posterPath! , completionHandler: { (imageData, error) -> Void in
                            if let image = UIImage(data: imageData!) {
                                print(image)
                            }
                        })
                    }
                }
                //print("D")
              //  for res in result! as [AnyObject] {
              //      print(res["file_path"])
              //  }
            }
        } */
       // getMovieDetails(550)
       /* if let id = movies[movieIndex].id as? Int {
            getMovieDetails(id)
        } */
    }
    
    func getMovieDetails(movieId: Int) {
        TMDBClient.sharedInstance().getMovieDetails("\(movieId)") { (result, error) -> Void in
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
                        })
                    }
                    
                }
            }
        }
    }
    
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(view)
        let poster = gesture.view!
        
        // move the image
        poster.center = CGPoint(x: view.bounds.width / 2 + translation.x, y: view.bounds.height / 2 + translation.y)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if poster.center.x < 100 {
                self.setMoviePoster(movieIndex)
            }
            else if poster.center.x > view.bounds.width - 100 {
                likedMovies.append(currMovie!)
                self.setMoviePoster(movieIndex)
            }
            
           /* if let id = movies[movieIndex].id as? Int {
                getMovieDetails(id)
            } */
            
            self.movieTitle.text = self.movies[self.movieIndex].title
            self.ratings.rating = self.movies[self.movieIndex].rating!
            
            poster.center = CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2 )
            
        }
    }
    
    func setMoviePoster(movInd: Int) {
        print(movInd)
        TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[4], filePath: movies[movInd].posterPath!) { (imageData, error) -> Void in
            if let image = UIImage(data: imageData!) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.poster.setImage(image, forState: .Normal)
                    self.currMovie = self.movies[movInd]
                    self.movieIndex += 1
                })
                
            }
        }
    }

    @IBAction func showLiked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LikedMoviesTableViewController") as! LikedMoviesTableViewController
            controller.movies = self.likedMovies
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showMore(sender: AnyObject) {
        //let informationPostingView : UINavigationController = viewContrl.storyboard?!.instantiateViewControllerWithIdentifier("InformationPostingView") as! UINavigationController
       // viewContrl.presentViewController(informationPostingView, animated: true, completion: nil)
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MoreInfoViewController") as! MoreInfoViewController
        controller.movie = currMovie
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
