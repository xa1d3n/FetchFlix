//
//  MovieRatingViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MovieRatingViewController: UIViewController {

    var movie : TMDBMovie?
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var ratings: CosmosView!
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
        
        if let rating = movie?.rating {
            ratings.rating = rating
        }
        
        if let voteCount = movie?.voteCount {
            ratings.text = "(\(voteCount))"
        }
        
        if let title = movie?.title {
            self.title = title
        }
        
    }
    
    func touchedTheStar(rating: Double) {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
