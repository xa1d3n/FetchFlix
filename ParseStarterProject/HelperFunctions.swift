//
//  HelperFunctions.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/16/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

struct HelperFunctions {
    static func startSpinner(view: UIView) -> UIActivityIndicatorView {
        var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
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
    
    static func getSimilarMovies(favMovie: FavoriteMovie) {
        TMDBClient.sharedInstance().getSimilarMovies(Int(favMovie.id!)!, page: 1) { (result, error) -> Void in
            if let movies = result {
                if movies.count > 0 {
                    self.addSimilarMoviesToCoreData(movies)
                    
                }
                
            }
            
        }
    }
}
