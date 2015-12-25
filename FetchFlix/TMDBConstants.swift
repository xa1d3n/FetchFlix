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
        static let SessionMApiKey: String = "13fb3e36ad2abde8fc8907aeb2cfe9f7b7f875d3"
        static let ParseApiKey : String = "3K2JfaWg7LaZlFAwJde2pm4dx2jEOP2lw871GrS5"
        static let ParseClientKey : String = "QrsTJeqmeH6p3sVqIWrriLG3eUecgWUjsmRmUFVq"
        
        // MARK: URLs
        static let BaseURL : String = "http://api.themoviedb.org/3/"
        static let BaseURLSecure : String = "https://api.themoviedb.org/3/"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
        static let secureBaseImageURLString : String =  "https://image.tmdb.org/t/p/"
        static let NetflixRouletteURL : String = "http://netflixroulette.net/api/api.php?title="
        static let FanTVURL : String = "https://www.fan.tv/movies/"
    }
    
    
    // MARK: Methods
    struct Methods {
        static let Account = "account"
        static let MovieDetails = "movie/{id}"
        static let SearchMovie = "search/movie"
        static let Similar = "similar"
        // MARK: Authentication
        static let AuthenticationTokenNew = "authentication/token/new"
        static let AuthenticationSessionNew = "authentication/session/new"
        static let RateMovie = "movie/{id}/rating"
        static let MovieImages = "movie/{id}/images"
        static let MovieVideo = "movie/{id}/videos"
        static let MovieCredits = "movie/{id}/credits"
        static let MovieWatchlist = "account/{id}/watchlist/movies"
        static let MovieFavorites = "account/{id}/favorite/movies"
        static let AccountIDWatchlist = "account/{id}/watchlist"
        static let AccountIDFavorites = "account/{id}/favorite"
        static let MovieStates = "movie/{id}/account_states"
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
    
    // MARK: URL Keys
    struct URLKeys {
        static let MovieId = "id"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        static let WatchList = "watchlist"
        
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
        static let Value =  "value"
        static let Rating = "vote_average"
        static let VoteCount = "vote_count"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let ImageFilePath = "file_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        static let MovieBackdrops = "backdrops"
        static let MoviePosters = "posters"
        static let MovieOverview = "overview"
        static let MovieRunTime = "runtime"
        static let TrailerSite = "site"
        static let TrailerKey = "key"
        static let MovieCast = "cast"
        static let ActorName = "name"
        
    }
    
}