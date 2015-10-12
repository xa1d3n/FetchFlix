//
//  TMDBConvenience.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    func getMovieForSearchString(searchString: String, completionHandler: (result: [TMDBMovie]?, error: NSError?)->Void) -> NSURLSessionDataTask {
        let parameters = [TMDBClient.ParameterKeys.Query: searchString]
        
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let results = result[TMDBClient.JSONResponseKeys.MovieResults] as? [[String: AnyObject]] {
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandler(result: movies, error: nil)
                }
                else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }

        return task
    }
    
    func getSimilarMovies(movieId: Int, completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let parameters = [TMDBClient.ParameterKeys.Page: 50]
        let method = "movie/\(movieId)/similar"
        
        let task = taskForGETMethod(method, parameters: parameters) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let results = result[TMDBClient.JSONResponseKeys.MovieResults] as? [[String : AnyObject]] {
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandler(result: movies, error: nil)
                }
                else {
                    completionHandler(result: nil, error: NSError(domain: "getSimilarMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getSimilarMovies"]))
                }
            }
        }
        return task
    }
}
