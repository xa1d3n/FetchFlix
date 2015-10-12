//
//  TMDBConstants.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    // MARK: Constants
    struct Constants {
        static let ApiKey : String = "87ba65df86c49ca89f776b1ac76342c2"
        
        // MARK: URLs
        static let BaseURL : String = "http://api.themoviedb.org/3/"
        static let BaseURLSecure : String = "https://api.themoviedb.org/3/"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
        static let secureBaseImageURLString : String =  "https://image.tmdb.org/t/p/"
    }
    
    
    // MARK: Methods
    struct Methods {
        static let Account = "account"
        static let SearchMovie = "search/movie"
        static let Similar = "similar"
        // MARK: Authentication
        static let AuthenticationTokenNew = "authentication/token/new"
        static let AuthenticationSessionNew = "authentication/session/new"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let Page = "page"
        static let posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
        static let profileSizes = ["w45", "w185", "h632", "original"]
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Movies
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
    }
    
}