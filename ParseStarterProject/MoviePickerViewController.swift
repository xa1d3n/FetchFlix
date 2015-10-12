//
//  MoviePickerViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MoviePickerViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    var searchTask : NSURLSessionDataTask?
    var poster : String?
    var posters = [UIImage?](count: 3, repeatedValue: nil)
    var posterInd : Int? = nil
    var movieIds = [Int?](count: 3, repeatedValue: nil)
    
    // movie data
    
    var movies = [TMDBMovie]()
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// Table view

extension MoviePickerViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FavoriteMoviesViewController") as! FavoriteMoviesViewController
        controller.poster = poster
        controller.posters = posters
        controller.posterImage = movies[indexPath.row].posterPath
        controller.movieIds[posterInd!] = movies[indexPath.row].id
        controller.posterInd = posterInd
        controller.movieIds = movieIds
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
}

// search bar
extension MoviePickerViewController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // cancel downloads
        if let task = searchTask {
            task.cancel()
        }
        
        // if empty
        if searchText == "" {
            movies = [TMDBMovie]()
            movieTableView.reloadData()
            return
        }
        
        searchTask = TMDBClient.sharedInstance().getMovieForSearchString(searchText, completionHandler: { (result, error) -> Void in
            if let movies = result {
                self.movies = movies
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.movieTableView!.reloadData()
                })
            }
        })
    }
}
