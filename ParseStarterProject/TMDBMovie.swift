//
//  TMDBMovie.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

struct TMDBMovie {
    var title = ""
    var id = 0
    var posterPath : String? = nil
    
    init(dictionary: [String: AnyObject]) {
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        
    }
    
    // convert to array of TMDBMovie
    static func moviesFromResults(results: [[String: AnyObject]]) -> [TMDBMovie] {
        var movies = [TMDBMovie]()
        
        for result in results {
            movies.append(TMDBMovie(dictionary: result))
        }
        
        return movies
    }
}
