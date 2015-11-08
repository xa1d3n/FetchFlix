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
    var movieTitles = [String?](count: 4, repeatedValue: nil)
    var posters = [UIImage?](count: 4, repeatedValue: nil)
    var posterPaths = [String?](count: 4, repeatedValue: nil)
    
    var posterInd : Int?
    var movieIds = [Int?](count: 4, repeatedValue: nil)
    
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
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("FavoriteMoviesCollectionViewController") as! FavoriteMoviesCollectionViewController
        controller.posters = posters
        controller.posterImage = movies[indexPath.row].posterPath
        movieIds[posterInd!] = movies[indexPath.row].id
        controller.movieIds = movieIds
        controller.posterInd = posterInd
        movieTitles[posterInd!] = movies[indexPath.row].title
        controller.movieTitles = movieTitles
        posterPaths[posterInd!] = movies[indexPath.row].posterPath
        controller.posterPaths = posterPaths
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
