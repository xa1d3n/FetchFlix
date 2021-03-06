//
//  LoginViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreData

class LoginViewController: UIViewController {
    
    var movieIds = [Int?](count: 3, repeatedValue: nil)
    var spinner : UIActivityIndicatorView?

  //  @IBOutlet weak var Open: UIBarButtonItem!
    let moc = DataController().managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        spinner = HelperFunctions.startSpinner(view)
        getUserFromCoreData()
    }

    // authenticate user
    @IBAction func authenticate(sender: UIButton) {
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let username = TMDBClient.sharedInstance().userID {
                        self.saveUserToCoreData(username)
                    }
                })
                
            }
            else {
                print("auth error")
            }
        }
    }
    
    // save user to core data
    func saveUserToCoreData(username: Int) {
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
        
        user.setValue(username, forKey: "userID")
        user.setValue(TMDBClient.sharedInstance().sessionID, forKey: "sessionID")
        
        do {
            try moc.save()
            // self.parseSignUp()
        } catch {
            fatalError("failure to save context: \(error)")
        }
        
        //HelperFunctions.getWatchListMovies(moc, user: user)
        let page = 1
        HelperFunctions.getWatchListMovies(moc, user: user, page: page) { (count) -> Void in
        }
        
        TMDBClient.sharedInstance().getFavoriteMovies({ (success, movies, errorString) -> Void in
            if (success == true) {
                var i = 0
                let count = movies?.count //2
                
                if count < 1 {
                    self.performSegueWithIdentifier("showSlider", sender: self)
                    HelperFunctions.stopSpinner(self.spinner!)
                }
                
                for movie in movies! {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.addToCoreData(movie, user: user, count: count!, iterator: i)
                    })
                    i++
                    if (i >= 4) {
                        break
                    }
                }
            }
        })
        
        do {
            try moc.save()
           // self.parseSignUp()
        } catch {
            fatalError("failure to save context: \(error)")
        }
    }
    
    // get user information from core data
    func getUserFromCoreData() {
        
        let userFetch = NSFetchRequest(entityName: "User")
        
        do {
            let fetchedUser = try moc.executeFetchRequest(userFetch) as! [User]
            
            if let user = fetchedUser.first {
                let userId = user.userID
                TMDBClient.sharedInstance().userID = userId as? Int
                
                if (user.sessionID == nil || user.sessionID == "") {
                    HelperFunctions.stopSpinner(self.spinner!)
                    parseSignUp()
                }
                else {
                    TMDBClient.sharedInstance().sessionID = user.sessionID
                    if (user.favoriteMovie!.count >= 4) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.performSegueWithIdentifier("showSlider", sender: self)
                            HelperFunctions.stopSpinner(self.spinner!)
                        })
                    }
                    else {
                        parseLogin()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.performSegueWithIdentifier("showSlider", sender: self)
                            HelperFunctions.stopSpinner(self.spinner!)
                        })
                    }
                }
                
            }
            else {
                HelperFunctions.stopSpinner(self.spinner!)
                parseSignUp()
            }

        } catch {
            fatalError("could not retrive user data \(error)")
        }
    }
    
    // add favorite movies to core data
    func addToCoreData(movie: TMDBMovie, user: User?, count: Int, iterator: Int) {
        let favMovie = NSEntityDescription.insertNewObjectForEntityForName("FavoriteMovie", inManagedObjectContext: moc) as? FavoriteMovie
        
        if let title = movie.title {
            favMovie!.setValue(title, forKey: "title")
        }
        if let id = movie.id {
            favMovie!.setValue("\(id)", forKey: "id")
        }
        if let posterPath = movie.posterPath {
            favMovie!.setValue(posterPath, forKey: "posterPath")
        }
        
        favMovie!.setValue("1", forKey: "page")
        HelperFunctions.downloadPoster(movie.posterPath)
        if let currUser = user {
            currUser.mutableSetValueForKey("favoriteMovie").addObject(favMovie!)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                HelperFunctions.getSimilarMovies(favMovie!, user: currUser, moc: self.moc, completion: { (result, error) -> Void in
                    if error == nil {
                        do {
                            try self.moc.save()
                        } catch {
                            fatalError("failure to save context: \(error)")
                        }
                        if (count >= 4 && iterator >= 3) {
                            self.parseLogin()
                            
                                self.performSegueWithIdentifier("showSlider", sender: self)
                                HelperFunctions.stopSpinner(self.spinner!)
                            
                        }
                        else if (count < 4 && iterator+1 == count) {
                            self.parseLogin()
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.performSegueWithIdentifier("showSlider", sender: self)
                                HelperFunctions.stopSpinner(self.spinner!)
                            })
                        }
                    }
                    
                })
            })
        }
    }
    
    // login to parse
    func parseLogin() {
        let user = PFUser()
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

                            } else {
                                // The login failed. Check error to see why.
                            }
                        }
                        
                    }
                    
                } else {
                    
                }
            }
            
        }
    }
    
    // sign up to parse
    func parseSignUp() {
        let user = PFUser()
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
                                self.performSegueWithIdentifier("showSlider", sender: self)
                            } else {
                                // The login failed. Check error to see why.
                            }
                        }

                    }
                    
                } else {
                    self.performSegueWithIdentifier("showSlider", sender: self)
                    // Hooray! Let them use the app now.
                }
            }

        }
    }

}
