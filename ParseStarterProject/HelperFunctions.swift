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
    
    static func getSimilarMovies(favMovie: FavoriteMovie, moc: NSManagedObjectContext, completion: (result: [TMDBMovie]) -> Void) {
        if var page = Int(favMovie.page!) {
            TMDBClient.sharedInstance().getSimilarMovies(Int(favMovie.id!)!, page: page) { (result, error) -> Void in
                if let movies = result {
                    page++
                    if movies.count > 0 {
                        
                        favMovie.setValue("\(page)", forKey: "page")
                        self.addSimilarMoviesToCoreData(movies, moc: moc, favMovie: favMovie)
                        completion(result: movies)
                    }
                    
                }
                
            }
        }

    }
    
    static func addSimilarMoviesToCoreData(movies: [TMDBMovie], moc: NSManagedObjectContext, favMovie: FavoriteMovie) {
        for movie in movies {
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
            
            favMovie.mutableSetValueForKey("similarMovie").addObject(similarMovie)
        }
        do {
            try moc.save()
        } catch {
            fatalError("failure to save context: \(error)")
        }
        
    }
    
    static func modifyMovieDBWatchlist(id: String?, watchlist: Bool) {
        if let id = id {
            TMDBClient.sharedInstance().postToWatchlist(id, watchlist: watchlist, completionHandler: { (result, error) -> Void in
                if error != nil {
                    print(error)
                }
                else {
                    print(result)
                }
            })
        }
    }
}
