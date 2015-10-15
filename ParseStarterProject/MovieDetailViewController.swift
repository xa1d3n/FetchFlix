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
    
    var currMovie : TMDBMovie?
    
    var likedMovies = [TMDBMovie]()
    
    var movieIndex = 0

    @IBOutlet weak var poster: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieIds = [17169, 54833, 43522]
        
       /* for movieId in movieIds {
            TMDBClient.sharedInstance().getSimilarMovies(movieId!, completionHandler: { (result, error) -> Void in
                if let movies = result {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.movies += movies
                        
                    })
                    
                }
                
            })
        } */
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        poster.addGestureRecognizer(gesture)
        poster.userInteractionEnabled = true
        
        
        //setMoviePoster(movieIndex)
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
            
            poster.center = CGPoint(x: view.bounds.width / 2 , y: view.bounds.height / 2 )
            
        }
    }
    
    func setMoviePoster(movInd: Int) {
        TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[4], filePath: movies[movInd].posterPath!) { (imageData, error) -> Void in
            if let image = UIImage(data: imageData!) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.poster.image = image
                    self.currMovie = self.movies[movInd]
                    self.movieIndex += 1
                })
                
            }
        }
    }

    @IBAction func showLiked(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("LikedMoviesTableViewController") as! LikedMoviesTableViewController
        controller.movies = likedMovies
        navigationController?.pushViewController(controller, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
