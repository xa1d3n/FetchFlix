//
//  HelperFunctions.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/16/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct HelperFunctions {
    static var watchList = Set<String>()
    static var passedList = Set<String>()
    
    static func startSpinner(view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        return activityIndicator
    }

    static func stopSpinner(spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    static func getSimilarMovies(favMovie: FavoriteMovie, user: User, moc: NSManagedObjectContext, completion: (result: [TMDBMovie]?, error: String?) -> Void) {
        let watchlistMovies = user.likedMovie?.allObjects as! [LikedMovie]
        let passedMovies = user.passedMovie?.allObjects as! [PassedMovie]
        
        for movie in watchlistMovies {
            if let id = movie.id {
                watchList.insert(id)
            }
        }
        
        for movie in passedMovies {
            if let id = movie.id {
                passedList.insert(id)
            }
        }
        
        if var page = Int(favMovie.page!) {
            TMDBClient.sharedInstance().getSimilarMovies(Int(favMovie.id!)!, page: page) { (result, error) -> Void in
                if let movies = result {
                    
                    page++
                    if movies.count > 0 {
                        
                        favMovie.setValue("\(page)", forKey: "page")
                        //self.addSimilarMoviesToCoreData(movies, moc: moc, favMovie: favMovie)
                        self.addSimilarMoviesToCoreData(movies, user: user, moc: moc, favMovie: favMovie, completion: { (success) -> Void in
                            if success {
                                
                                completion(result: movies, error: nil)
                            }
                        })
                        
                    }
                    else {
                        completion(result: nil, error: "Out of similar movies")
                    }
                    
                }
                
            }
        }

    }
    
    static func addSimilarMoviesToCoreData(movies: [TMDBMovie], user: User, moc: NSManagedObjectContext, favMovie: FavoriteMovie, completion: (success: Bool) -> Void) {
        for movie in movies {
            let movieId = "\(movie.id!)"
            if (!watchList.contains(movieId) && !passedList.contains(movieId)) {
                let similarMovie = NSEntityDescription.insertNewObjectForEntityForName("SimilarMovie", inManagedObjectContext: moc) as! SimilarMovie
                if let title = movie.title {
                    similarMovie.setValue(title, forKey: "title")
                }
                
                if let id = movie.id {
                    similarMovie.setValue("\(id)", forKey: "id")
                }
                
                if let posterPath = movie.posterPath {
                    similarMovie.setValue(posterPath, forKey: "posterPath")
                }
                if let rating = movie.rating {
                    similarMovie.setValue("\(rating)", forKey: "rating")
                }
                
                if let voteCount = movie.voteCount {
                    similarMovie.setValue("\(voteCount)", forKey: "ratingCount")
                }
                
                if let released = movie.releaseDate {
                    similarMovie.setValue("\(released)", forKey: "released")
                }
                
                favMovie.mutableSetValueForKey("similarMovie").addObject(similarMovie)
            }
        }
        do {
            try moc.save()
            
            if favMovie.similarMovie?.allObjects.count < 1 {
                self.getSimilarMovies(favMovie, user: user, moc: moc, completion: { (result) -> Void in
                    completion(success: false)
                })
            }
            else {
                completion(success: true)
            }
        } catch {
            completion(success: false)
            fatalError("failure to save context: \(error)")
        }
        
        
        
    }
    
    static func modifyMovieDBFavorite(id: String?, favorite: Bool, completion: (success: Bool)->Void) {
        if let id = id {
            TMDBClient.sharedInstance().postToFavorites(id, favorite: favorite, completionHandler: { (result, error) -> Void in
                if error != nil {
                    completion(success: false)
                    print(error)
                }
                else {
                    completion(success: true)
                }
            })
        }
    }
    
    static func downloadPoster(posterImage: String?) {
        if let posterImage = posterImage {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[3], filePath: posterImage, completionHandler: { (imageData, error) -> Void in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.saveImageData(image, posterPath: posterImage)
                    })
                }
            })
        }
    }
    
    static func removeImageData(posterPath: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = "\(paths)/\(posterPath)"
        
        let filemgr = NSFileManager.defaultManager()
        
        do {
            try filemgr.removeItemAtPath(filePath)
        } catch {
            print("could not remove file")
        }
    }
    
    static func saveImageData(posterImg: UIImage, posterPath: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePathToWrite = "\(paths)/\(posterPath)"
        
        let jpgImageData = UIImageJPEGRepresentation(posterImg, 1.0)
        jpgImageData?.writeToFile(filePathToWrite, atomically: true)
    }
    
    static func styleButton(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:0.35, green:0.73, blue:0.71, alpha:1.0).CGColor
    }
    
    static func getWatchListMovies(moc: NSManagedObjectContext, user: User, page: Int, completion: (success: Bool) -> Void) {
        TMDBClient.sharedInstance().getMovieWatchlist(page) { (success, movies, errorString) -> Void in
            if success {
                if let movies = movies {
                    for movie in movies {
                        let likedMovie = NSEntityDescription.insertNewObjectForEntityForName("LikedMovie", inManagedObjectContext: moc) as! LikedMovie
                        
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
                        
                        if let overview = movie.overview {
                            likedMovie.overview = overview
                        }
                        
                        if let released = movie.releaseDate {
                            likedMovie.released = released
                        }

                        
                        
                        user.mutableSetValueForKey("likedMovie").addObject(likedMovie)
                        
                        do {
                            try moc.save()
                        } catch {
                            fatalError("failure to save context: \(error)")
                        }
                        
                    }
                    if movies.count == 20 {
                        var nextPage = page
                        nextPage++
                        self.getWatchListMovies(moc, user: user, page: nextPage, completion: { (count) -> Void in
                            
                        })
                    }
                    else {
                        completion(success: true)
                    }
                }
            }
        }
    }
    
    static func modifyMovieDBWatchlist(id: String?, watchlist: Bool, completion: (success: Bool) -> Void) {
        if let id = id {
            TMDBClient.sharedInstance().postToWatchlist(id, watchlist: watchlist, completionHandler: { (result, error) -> Void in
                if error != nil {
                    print(error)
                    completion(success: false)
                }
                else {
                    completion(success: true)
                }
            })
        }
    }
    
    static func addMovieToWatchlist(movie: LikedMovie?, user: User?, moc: NSManagedObjectContext?, completion: (success: Bool) -> Void) {
        
        if let movie = movie {
            HelperFunctions.modifyMovieDBWatchlist(movie.id, watchlist: true) { (success) -> Void in
                if success {
                    user!.mutableSetValueForKey("likedMovie").addObject(movie)
                    
                    do {
                        try moc!.save()
                        completion(success: true)
                    } catch {
                        completion(success: false)
                        fatalError("failure to save context: \(error)")
                    }
                }
            }
        }
    }
    
    static func removeMovieFromWatchlist(id: String?, user: User?, moc: NSManagedObjectContext?, completion: (success: Bool) -> Void) {
        if let id = id {
            HelperFunctions.modifyMovieDBWatchlist(id, watchlist: false) { (success) -> Void in
                if success {
                    let likedMovies = user?.likedMovie?.allObjects as? [LikedMovie]
                    for movie in likedMovies! {
                        if movie.id! == id {
                            user?.mutableSetValueForKey("likedMovie").removeObject(movie)
                            do {
                                try moc!.save()
                                completion(success: true)
                            } catch {
                                completion(success: false)
                                fatalError("failure to save context: \(error)")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
}