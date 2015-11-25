//
//  FavoriteMoviesCollectionViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreData

private let reuseIdentifier = "cell"

class FavoriteMoviesCollectionViewController: UICollectionViewController {
    
    var posters = [UIImage?](count: 4, repeatedValue: nil)
    var posterPaths = [String?](count: 4, repeatedValue: nil)
    var posterInd : Int? = nil
    var movieTitles = [String?](count: 4, repeatedValue: nil)
    
    var movieIds = [Int?](count: 4, repeatedValue: nil)
    var posterImage: String? = nil
    
    var similarMovies = [TMDBMovie]()
    var likedMovies = [LikedMovie]()
    
    let moc = DataController().managedObjectContext
    var user : User?
    
    var pfUser = PFUser()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes

        // Do any additional setup after loading the view.
        
        /*TMDBClient.sharedInstance().getFavoriteMovies { (success, movies, errorString) -> Void in
            print(movies)
        } */
        
        //HelperFunctions.modifyMovieDBFavorite("87101", favorite: false)
        
        getUSerFromCoreData()
    }
    
    func getUSerFromCoreData() {
        let userFetch = NSFetchRequest(entityName: "User")
        
        do {
            let fetchedUser = try moc.executeFetchRequest(userFetch) as! [User]
            
            //fetchedUser.first?.mutableSetValueForKey("favofaf").addObject(<#T##object: AnyObject##AnyObject#>)
            if let user = fetchedUser.first {
                self.user = user
                getFavoriteMovieFromCoreData()
            }
            
        } catch {
            fatalError("could not retrive user data \(error)")
        }
    }
    
    func getFavoriteMovieFromCoreData() {
        var ind = 0
        
        getLikedMovies()
        
        let favMovies = user?.favoriteMovie?.allObjects as? [FavoriteMovie]
        for movie in favMovies!{
            movieTitles[ind] = movie.title
            movieIds[ind] = Int(movie.id!)
            posterPaths[ind] = movie.posterPath
            getImageData(movie.posterPath!, ind: ind)
            ind++
        }
        
        self.collectionView?.reloadData()
    }
    
    func getLikedMovies() {
        likedMovies = (user?.likedMovie?.allObjects as? [LikedMovie])!
        
        if likedMovies.count < 1 {
            TMDBClient.sharedInstance().getMovieWatchlist { (success, movies, errorString) -> Void in
                if success {
                    if let movies = movies {
                        for movie in movies {
                            let likedMovie = NSEntityDescription.insertNewObjectForEntityForName("LikedMovie", inManagedObjectContext: self.moc) as! LikedMovie
                            
                            if let title = movie.title {
                                likedMovie.title = title
                            }
                            
                            if let id = movie.id {
                                likedMovie.id = "\(id)"
                            }
                            if let rating = movie.rating {
                                likedMovie.rating = "\(rating)"
                            }
                            
                            if let voteCount = movie.voteCount {
                               likedMovie.ratingCount = "\(voteCount)"
                            }
                            
                            if let posterPath = movie.posterPath {
                                likedMovie.posterPath = posterPath
                            }
                            
                            
                            self.user!.mutableSetValueForKey("likedMovie").addObject(likedMovie)
                            
                            do {
                                try self.moc.save()
                            } catch {
                                fatalError("failure to save context: \(error)")
                            }

                        }
                    }
                }
            }
        }
    }
    
    func getImageData(posterPath: String, ind: Int) {
        
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let getImagePath = (paths as NSString).stringByAppendingPathComponent(posterPath)
        
        let image = UIImage(contentsOfFile: getImagePath)
        
        if image == nil {
            
            print("missing image at: (path)")
        }
        else {
            posters[ind] = image
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func addFavoritesToCoreData(ind: Int) {
        let favMovie = NSEntityDescription.insertNewObjectForEntityForName("FavoriteMovie", inManagedObjectContext: moc) as! FavoriteMovie
        
        favMovie.setValue(movieTitles[ind], forKey: "title")
        favMovie.setValue("\(movieIds[ind])", forKey: "id")
        favMovie.setValue(posterPaths[ind], forKey: "posterPath")
        //saveImageData(posters[ind]!, posterPath: posterPaths[ind]!)
        if let currUser = user {
            currUser.mutableSetValueForKey("favoriteMovie").addObject(favMovie)
        }
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save context: \(error)")
        }

    }
    
    func saveImageData(posterImg: UIImage, posterPath: String) {
        let fileManager = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let filePathToWrite = "\(paths)/\(posterPath)"
        
        let jpgImageData = UIImageJPEGRepresentation(posterImg, 1.0)
        jpgImageData?.writeToFile(filePathToWrite, atomically: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoviePosterCollectionViewCell
        
        if let poster = posters[indexPath.row] {
            cell.poster.image = poster
        }
        else {
            let image = UIImage(named: "Add")
            cell.poster.image = image
        }
        
        
        
        
        cell.title.text = movieTitles[indexPath.row]
        
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        posterInd = indexPath.row
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MoviePickerViewController") as! MoviePickerViewController
        controller.posters = posters
        controller.posterInd = posterInd
        controller.movieIds = movieIds
        controller.movieTitles = movieTitles
        controller.posterPaths = posterPaths
        controller.user = user
        controller.moc = moc
        self.navigationController!.pushViewController(controller, animated: true)
    }

    @IBAction func showPicker(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
