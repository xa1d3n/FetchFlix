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
    var rating = 0.0
    var voteCount = 0
    var overview : String?
    var runtime : Int?
    var releaseDate : String?
    
    init(dictionary: [String: AnyObject]) {
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        rating = dictionary[TMDBClient.JSONResponseKeys.Rating] as! Double
        voteCount = dictionary[TMDBClient.JSONResponseKeys.VoteCount] as! Int
        overview = dictionary[TMDBClient.JSONResponseKeys.MovieOverview] as? String
        runtime = dictionary[TMDBClient.JSONResponseKeys.MovieRunTime] as? Int
        releaseDate = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String
    }
    
    // convert to array of TMDBMovie
    static func moviesFromResults(results: [[String: AnyObject]]) -> [TMDBMovie] {
        var movies = [TMDBMovie]()
        
        for result in results {
            movies.append(TMDBMovie(dictionary: result))
        }
        
        return movies
    }
    
    static func movieFromResults(results: [String: AnyObject]) -> [TMDBMovie] {
        var movie = [TMDBMovie]()
        

        movie.append(TMDBMovie(dictionary: results))

        
        return movie
    }
}
