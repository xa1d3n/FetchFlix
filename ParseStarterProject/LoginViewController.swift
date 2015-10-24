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

                    
                    self.parseSignUp()
                    
                    
                    
                   // let controller = self.storyboard?.instantiateViewControllerWithIdentifier("showFavPicker") as! FavoriteMoviesCollectionViewController
                   // self.presentViewController(controller, animated: true, completion: nil)
                })
                
            }
            else {
                print("auth error bitch")
            }
        }
    }
    
    func parseSignUp() {
        var user = PFUser()
        if let username = TMDBClient.sharedInstance().userID {
            user.username = "\(username)"
            user.password = ""
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    if error.code == 202 {
                        
                        PFUser.logInWithUsernameInBackground("\(username)", password:"") {
                            (user: PFUser?, error: NSError?) -> Void in
                            if user != nil {
                                self.performSegueWithIdentifier("showFavPicker", sender: self)
                            } else {
                                // The login failed. Check error to see why.
                            }
                        }

                    }
                    
                } else {
                    self.performSegueWithIdentifier("showFavPicker", sender: self)
                    // Hooray! Let them use the app now.
                }
            }

        }
    }

}
