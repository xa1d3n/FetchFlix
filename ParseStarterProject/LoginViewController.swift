//
//  LoginViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    var movieIds = [Int?](count: 3, repeatedValue: nil)
    var movies = [TMDBMovie]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieIds = [17169, 54833, 43522]
        
        for movieId in movieIds {
            TMDBClient.sharedInstance().getSimilarMovies(movieId!, completionHandler: { (result, error) -> Void in
                if let movies = result {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.movies += movies
                        
                    })
                    
                }
                
            })
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func authenticate(sender: UIButton) {
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var user:PFUser = PFUser()
                    if let username = TMDBClient.sharedInstance().userID {
                        user.username = "\(username)"
                        user.password = ""
                        user["favoriteMovies"].addUniqueObjectsFromArray(<#T##objects: [AnyObject]##[AnyObject]#>, forKey: <#T##String#>)
                        user.signUpInBackgroundWithBlock {
                            (succeeded: Bool, error: NSError?) -> Void in
                            if let error = error {
                                
                                // Show the errorString somewhere and let the user try again.
                            } else {
                                // Hooray! Let them use the app now.
                            }
                        }
                    }
                   
                    
                    
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
                    controller.movies = self.movies
                    self.presentViewController(controller, animated: true, completion: nil)
                })
                
            }
            else {
                print("auth error bitch")
            }
        }
    }

}
