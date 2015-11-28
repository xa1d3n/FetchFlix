//
//  LikedMoviesTableViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreData

class LikedMoviesTableViewController: UITableViewController {
    
    var movies = [LikedMovie]()
    
    var watchListMovies = [TMDBMovie]()
    
    var moc : NSManagedObjectContext?
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Watchlist"
        getLikedMoviesFromCoreData()
        
    }
    
    func getWatchListMovies() {
        TMDBClient.sharedInstance().getMovieWatchlist { (success, movies, errorString) -> Void in
            if success {
                self.watchListMovies = movies!
            }
        }
    }
    
    func getLikedMoviesFromCoreData() {
        movies = user?.likedMovie?.allObjects as! [LikedMovie]
        self.tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel!.text = movies[indexPath.row].title
        cell.imageView?.image = nil
        //print(movies[indexPath.row].)
        
        if let poster = movies[indexPath.row].posterPath {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[0], filePath: poster, completionHandler: { (imageData, error) -> Void in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.imageView?.image = image
                        cell.setNeedsLayout()
                    })
                }
            })
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieRatingViewController") as! MovieRatingViewController
        controller.movie = movies[indexPath.row]
        controller.moc = moc
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let movieToDelete = movies[indexPath.row]
        movies.removeAtIndex(indexPath.row)
        removeFromCoreData(movieToDelete)
        tableView.reloadData()
    }
    
    func removeFromCoreData(movieToDelete: LikedMovie) {
        HelperFunctions.modifyMovieDBWatchlist(movieToDelete.id, watchlist: false)
        let likedMovies = user?.likedMovie?.allObjects as? [LikedMovie]
        for movie in likedMovies! {
            if movie.id! == movieToDelete.id {
                user?.mutableSetValueForKey("likedMovie").removeObject(movie)
                do {
                    try moc!.save()
                } catch {
                    fatalError("failure to save context: \(error)")
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
