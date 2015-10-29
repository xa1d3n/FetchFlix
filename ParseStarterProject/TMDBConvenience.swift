//
//  TMDBConvenience.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

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
        let parameters = [TMDBClient.ParameterKeys.Page: 1]
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
    
    func getMovieImages(movieId: String, completionHandler: (result: [TMDBImages]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        var mutableMethod : String = Methods.MovieImages
        mutableMethod = TMDBClient.subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.MovieId, value: movieId)!
        
        let parameters = ["language": "en"]
        
        let task = taskForGETMethod(mutableMethod, parameters: parameters) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let results = result[TMDBClient.JSONResponseKeys.MoviePosters] as? [[String : AnyObject]] {
                    let posters = TMDBImages.moviesFromResults(results)
                    completionHandler(result: posters, error: nil)
                }
                else {
                    completionHandler(result: nil, error: NSError(domain: "getMovieImages parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMovieImages"]))
                }
            }
        }
        
        return task
    }
    
    func getMovieDetails(movieId: String, completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        var mutableMethod : String = Methods.MovieDetails
        mutableMethod = TMDBClient.subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.MovieId, value: movieId)!
        
        let parameters = ["language": "en"]
        
        let task = taskForGETMethod(mutableMethod, parameters: parameters) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let results = result as? [String: AnyObject] {
                    let movie = TMDBMovie.movieFromResults(results)
                    completionHandler(result: movie, error: nil)
                }
                else {
                     completionHandler(result: nil, error: NSError(domain: "getMovieDetails parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMovieDetails"]))
                }
            }
        }
        
        return task
    }
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* Chain completion handlers for each request so that they run one after the other */
        self.getRequestToken() { (success, requestToken, errorString) in
            
            if success {
                
                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
                    
                    if success {
                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
                            
                            if success {
                                
                                /* Success! We have the sessionID! */
                                self.sessionID = sessionID
                                
                                self.getUserID() { (success, userID, errorString) in
                                    
                                    if success {
                                        
                                        if let userID = userID {
                                            
                                            /* And the userID 😄! */
                                            self.userID = userID
                                        }
                                    }
                                    
                                    completionHandler(success: success, errorString: errorString)
                                }
                            } else {
                                completionHandler(success: success, errorString: errorString)
                            }
                        }
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getRequestToken(completionHandler: (success: Bool, requestToken: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        /* 2. Make the request */
        taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (JSONResult, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
            } else {
                if let requestToken = JSONResult[TMDBClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandler(success: true, requestToken: requestToken, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(JSONResult)")
                    completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
                }
            }
        }
    }
    
    
    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
    func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
        let request = NSURLRequest(URL: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("TMDBAuthViewController") as! TMDBAuthViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandler = completionHandler
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        })
    }
    
    func getSessionID(requestToken: String?, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.RequestToken : requestToken!]
        
        /* 2. Make the request */
        taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
            } else {
                if let sessionID = JSONResult[TMDBClient.JSONResponseKeys.SessionID] as? String {
                    completionHandler(success: true, sessionID: sessionID, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                    completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
                }
            }
        }
    }
    
    func getUserID(completionHandler: (success: Bool, userID: Int?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        
        /* 2. Make the request */
        taskForGETMethod(Methods.Account, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, userID: nil, errorString: "Login Failed (User ID).")
            } else {
                if let userID = JSONResult[TMDBClient.JSONResponseKeys.UserID] as? Int {
                    completionHandler(success: true, userID: userID, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.UserID) in \(JSONResult)")
                    completionHandler(success: false, userID: nil, errorString: "Login Failed (User ID).")
                }
            }
        }
    }
    
    // rate movie
    func rateMovie(movieId: String, rating: Double, completionHandler: (result: Int?, error: NSError?) -> Void) {
        let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod : String = Methods.RateMovie
        mutableMethod = TMDBClient.subtituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.MovieId, value: movieId)!
        let jsonBody : [String : AnyObject] = [
            TMDBClient.JSONResponseKeys.Value: rating
        ]
        
        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (JSONResult, error) -> Void in
            if let error = error {
                completionHandler(result: nil, error: error)
            }
            else {
                if let results = JSONResult[TMDBClient.JSONResponseKeys.StatusCode] as? Int {
                    completionHandler(result: results, error: nil)
                }
                else {
                    completionHandler(result: nil, error: NSError(domain: "postToWatchlist parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToWatchlist"]))
                }
            }
        }
    }
}
