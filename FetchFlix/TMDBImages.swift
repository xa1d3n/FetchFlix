//
//  TMDBMovie.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

struct TMDBImages {
    var posterPath : String? = nil
    
    init(dictionary: [String: AnyObject]) {
        posterPath = dictionary[TMDBClient.JSONResponseKeys.ImageFilePath] as? String
        
    }
    
    // convert to array of TMDBMovie
    static func moviesFromResults(results: [[String: AnyObject]]) -> [TMDBImages] {
        var movies = [TMDBImages]()
        
        for result in results {
            movies.append(TMDBImages(dictionary: result))
        }
        
        return movies
    }
}
