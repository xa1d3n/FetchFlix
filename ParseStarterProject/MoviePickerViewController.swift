//
//  MoviePickerViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreData

class MoviePickerViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    var searchTask : NSURLSessionDataTask?
    var movieTitles = [String?](count: 4, repeatedValue: nil)
    var posters = [UIImage?](count: 4, repeatedValue: nil)
    var posterPaths = [String?](count: 4, repeatedValue: nil)
    
    var posterInd : Int?
    var movieIds = [Int?](count: 4, repeatedValue: nil)
    
    var moc : NSManagedObjectContext?
    var user : User?
    
    var favMovie : FavoriteMovie?
    
    // movie data
    
    var movies = [TMDBMovie]()
    var controller = FavoriteMoviesCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieSearchBar.placeholder = "Search for a movie..."
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
        saveToCoreData(movieIds[posterInd!], newId: movies[indexPath.row].id!, title: movies[indexPath.row].title!, posterPath: movies[indexPath.row].posterPath!)
        
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("FavoriteMoviesCollectionViewController") as! FavoriteMoviesCollectionViewController
        controller.posters = posters
        controller.posterImage = movies[indexPath.row].posterPath
        movieIds[posterInd!] = movies[indexPath.row].id
        controller.movieIds = movieIds
        controller.posterInd = posterInd
        movieTitles[posterInd!] = movies[indexPath.row].title
        controller.movieTitles = movieTitles
        posterPaths[posterInd!] = movies[indexPath.row].posterPath
        controller.posterPaths = posterPaths
        
    }
    
    func downloadPoster(posterImage: String?) {
        if let posterImage = posterImage {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[3], filePath: posterImage, completionHandler: { (imageData, error) -> Void in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.posters[self.posterInd!] = image
                        self.saveImageData(image, posterPath: posterImage)
                        self.navigationController!.pushViewController(self.controller, animated: true)
                    })
                }
            })
        }
    }
    
    func saveToCoreData(oldId: Int?=nil, newId: Int, title: String, posterPath: String) {
        
        if (oldId != newId && oldId != nil) {
            let favMovies = user?.favoriteMovie?.allObjects as? [FavoriteMovie]
            for movie in favMovies! {
                if movie.id! == "\(oldId!)" {
                    //HelperFunctions.modifyMovieDBFavorite("\(oldId!)", favorite: false)
                    HelperFunctions.modifyMovieDBFavorite("\(oldId!)", favorite: false, completion: { (success) -> Void in
                        
                    })
                    user?.mutableSetValueForKey("favoriteMovie").removeObject(movie)
                    do {
                        try moc!.save()
                    } catch {
                        fatalError("failure to save context: \(error)")
                    }
                }
            }
        }
        if (oldId != newId) {
            //HelperFunctions.modifyMovieDBFavorite("\(newId)", favorite: true)
            HelperFunctions.modifyMovieDBFavorite("\(oldId!)", favorite: true, completion: { (success) -> Void in
                
            })
            favMovie = NSEntityDescription.insertNewObjectForEntityForName("FavoriteMovie", inManagedObjectContext: moc!) as? FavoriteMovie
            
            favMovie!.setValue(title, forKey: "title")
            favMovie!.setValue("\(newId)", forKey: "id")
            favMovie!.setValue(posterPath, forKey: "posterPath")
            favMovie!.setValue("1", forKey: "page")
            downloadPoster(posterPath)
            if let currUser = user {
                currUser.mutableSetValueForKey("favoriteMovie").addObject(favMovie!)
                HelperFunctions.getSimilarMovies(favMovie!, user: currUser, moc: moc!, completion: { (result) -> Void in
                    
                })
                do {
                    try moc!.save()
                } catch {
                    fatalError("failure to save context: \(error)")
                }
            }
            
        }
        
    }
    
    func removeImageData(posterPath: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = "\(paths)/\(posterPath)"
        
        let filemgr = NSFileManager.defaultManager()
        
        do {
            try filemgr.removeItemAtPath(filePath)
        } catch {
            print("could not remove file")
        }
    }
    
    func saveImageData(posterImg: UIImage, posterPath: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePathToWrite = "\(paths)/\(posterPath)"
        
        let jpgImageData = UIImageJPEGRepresentation(posterImg, 1.0)
        jpgImageData?.writeToFile(filePathToWrite, atomically: true)
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
