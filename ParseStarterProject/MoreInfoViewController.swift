//
//  MoreInfoViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MediaPlayer

class MoreInfoViewController: UIViewController {
    
    var movie : TMDBMovie?
    var trailerKey: String?
    var id: String?
    var filmTitle: String?
    var releaseDate: String?
    var summary: String?
    var posterPath: String?
    var movieRunTime : String?
    var posterImage : UIImage?
    

    @IBOutlet weak var movieSummary: UILabel!
    @IBOutlet weak var runTime: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var poster: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
        self.title = "SFDFDFS"
        self.navigationController?.title = "FDS"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}
