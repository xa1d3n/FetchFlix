//
//  PreviewViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var rating: CosmosView!
    var filmTitle : String!
    var posterImage : UIImage!
    var movieRating : Double!
    var movie : LikedMovie?
    var moc : NSManagedObjectContext?
    var user : User?
    var presentingVC : LikedMoviesTableViewController?
    
    var previewActions : [UIPreviewActionItem] {
        let info = UIPreviewAction(title: "More Information", style: UIPreviewActionStyle.Destructive) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            self.info()
        }
        
        return [info]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        movieTitle.text = filmTitle
        poster.image = posterImage
        rating.rating = movieRating
    }
    
    // show more infor about movie
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
                                let navController = self.presentingVC!.storyboard?.instantiateViewControllerWithIdentifier("MoreDetailsNav") as! UINavigationController
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
                                self.presentingVC!.presentViewController(navController, animated: true, completion: nil)
                                
                            })
                        }
                    }
                    
                }
            }
        }
    }
    
    
}
