//
//  TMDBMovie.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

struct TMDBMovie {
    var title : String? = ""
    var id : Int? = 0
    var posterPath : String? = nil
    var rating : Double? = 0.0
    var voteCount : Int? = 0
    var overview : String?
    var runtime : Int?
    var releaseDate : String?
    var trailerSite : String?
    var trailerKey : String?
    var actorName :String?
    var watchlist : Bool?
    var favorited : Bool?
    var genre : String?
    
    init(dictionary: [String: AnyObject]) {
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as? String
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as? Int
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        rating = dictionary[TMDBClient.JSONResponseKeys.Rating] as? Double
        voteCount = dictionary[TMDBClient.JSONResponseKeys.VoteCount] as? Int
        overview = dictionary[TMDBClient.JSONResponseKeys.MovieOverview] as? String
        runtime = dictionary[TMDBClient.JSONResponseKeys.MovieRunTime] as? Int
        releaseDate = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String
        trailerSite = dictionary[TMDBClient.JSONResponseKeys.TrailerSite] as? String
        trailerKey = dictionary[TMDBClient.JSONResponseKeys.TrailerKey] as? String
        actorName = dictionary[TMDBClient.JSONResponseKeys.ActorName] as? String
        watchlist = dictionary[TMDBClient.JSONResponseKeys.WatchList] as? Bool
        favorited = dictionary[TMDBClient.JSONBodyKeys.Favorite] as? Bool
        if let genres = dictionary["genres"] {
            genre = genres[0]["name"] as? String
        }
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
