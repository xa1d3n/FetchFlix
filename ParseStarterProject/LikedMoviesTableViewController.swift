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
    }
    
    override func viewWillAppear(animated: Bool) {
        searchActive = false
        super.viewWillAppear(true)
        getLikedMoviesFromCoreData()
    }
    
    func getLikedMoviesFromCoreData() {
        movies = user?.likedMovie?.allObjects as! [LikedMovie]
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchActive || filtered.count > 0) {
            setSearchBarText(filtered.count)
            return filtered.count
        }
        setSearchBarText(movies.count)
        return movies.count
    }
    
    func setSearchBarText(count: Int) {
        search.placeholder = "Search \(count) Movies"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if (searchActive || filtered.count > 0) {
            if (indexPath.row < filtered.count) {
                cell.textLabel!.text = filtered[indexPath.row].title
                //cell.detailTextLabel?.text = movies[indexPath.row].released
                cell.imageView?.image = nil
                //print(movies[indexPath.row].)
                
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (searchActive  && filtered.count > 0) {
            let movieToDelete = filtered[indexPath.row]
            filtered.removeAtIndex(indexPath.row)
            
            var i = 0
            for movie in movies {
                if movie.id == movieToDelete.id {
                    movies.removeAtIndex(i)
                    break
                }
                i++
            }
            removeFromCoreData(movieToDelete)
        }
        else {
            let movieToDelete = movies[indexPath.row]
            movies.removeAtIndex(indexPath.row)
            removeFromCoreData(movieToDelete)
        }
        tableView.reloadData()
    }
    
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
