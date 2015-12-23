//
//  LikedMoviesTableViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreData

class LikedMoviesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var movies = [LikedMovie]()
    var filtered = [LikedMovie]()
    var selectedMovie : LikedMovie?
    
    @IBOutlet weak var search: UISearchBar!
    var watchListMovies = [TMDBMovie]()
    
    @IBOutlet var table: UITableView!
    var moc : NSManagedObjectContext?
    var user : User?
    
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Watchlist"
        search.delegate = self
        
        // force peek
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: self.tableView)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        searchActive = false
        super.viewWillAppear(true)
        getLikedMoviesFromCoreData()
    }
    
    // get movies from watchlist
    func getLikedMoviesFromCoreData() {
        movies = user?.likedMovie?.allObjects as! [LikedMovie]
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // show filtered data if searching
        if (searchActive || filtered.count > 0) {
            setSearchBarText(filtered.count)
            return filtered.count
        }
        setSearchBarText(movies.count)
        return movies.count
    }
    
    // change searchbar placeholder text
    func setSearchBarText(count: Int) {
        search.placeholder = "Search \(count) Movies"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if (searchActive || filtered.count > 0) {
            if (indexPath.row < filtered.count) {
                cell.textLabel!.text = filtered[indexPath.row].title
                cell.detailTextLabel?.text = filtered[indexPath.row].released
                cell.imageView?.image = nil
                
                // retreive movie poster
                if let poster = filtered[indexPath.row].posterPath {
                    TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[0], filePath: poster, completionHandler: { (imageData, error) -> Void in
                        if let image = UIImage(data: imageData!) {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                cell.imageView?.image = image
                                cell.setNeedsLayout()
                            })
                        }
                    })
                }
            }

        }
        else {
            cell.textLabel!.text = movies[indexPath.row].title
            cell.detailTextLabel?.text = movies[indexPath.row].released
            cell.imageView?.image = nil
            
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
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        resignFirstResponder()
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieRatingViewController") as! MovieRatingViewController
        if (searchActive  && filtered.count > 0) {
            controller.movie = filtered[indexPath.row]
            controller.moc = moc
            controller.user = user
        }
        else {
            controller.movie = movies[indexPath.row]
            controller.moc = moc
            controller.user = user
        }

        navigationController?.pushViewController(controller, animated: true)
    }
    
    // delete movie from watchlist and core data
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (searchActive  && filtered.count > 0) {
            let movieToDelete = filtered[indexPath.row]
            
            var i = 0
            for movie in movies {
                if movie.id == movieToDelete.id {
                    movies.removeAtIndex(i)
                    break
                }
                i++
            }
            removeFromCoreData(movieToDelete)
            filtered.removeAtIndex(indexPath.row)
        }
        else {
            let movieToDelete = movies[indexPath.row]
            removeFromCoreData(movieToDelete)
            movies.removeAtIndex(indexPath.row)
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    // remove deleted movie from core data
    func removeFromCoreData(movieToDelete: LikedMovie) {
        HelperFunctions.removeMovieFromWatchlist(movieToDelete.id, user: user, moc: moc) { (success) -> Void in
            if success {
                print("deleted from watchlist")
            }
            else {
                print("coudl not remove from watchilst")
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    // filter results by title
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = movies.filter({
            ($0.title?.containsString(searchText))!
        })
        if filtered.count == 0 {
            searchActive = false
        }
        else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
