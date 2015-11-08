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
    var movies = [TMDBMovie]()

    let moc = DataController().managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* movieIds = [17169, 54833, 43522]
        
        for movieId in movieIds {
            TMDBClient.sharedInstance().getSimilarMovies(movieId!, completionHandler: { (result, error) -> Void in
                if let movies = result {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.movies += movies
                        
                    })
                    
                }
                
            })
        } */
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        getUserFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func authenticate(sender: UIButton) {
        TMDBClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let username = TMDBClient.sharedInstance().userID {
                        self.saveUserToCoreData(username)
                    }
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
    
    func saveUserToCoreData(username: Int) {
        let entity = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
        
        entity.setValue(username, forKey: "userID")
        entity.setValue(TMDBClient.sharedInstance().sessionID, forKey: "sessionID")
        
        do {
            try moc.save()
        } catch {
            fatalError("failure to save context: \(error)")
        }
    }
    
    func getUserFromCoreData() {
        let userFetch = NSFetchRequest(entityName: "User")
        
        do {
            let fetchedUser = try moc.executeFetchRequest(userFetch) as! [User]
            
            //fetchedUser.first?.mutableSetValueForKey("favofaf").addObject(<#T##object: AnyObject##AnyObject#>)
            if let user = fetchedUser.first {
                
                if let userId = user.userID {
                    TMDBClient.sharedInstance().userID = userId as? Int
                    TMDBClient.sharedInstance().sessionID = user.sessionID
                    
                    print(user.favoriteMovie!.count)
                    if (user.favoriteMovie!.count >= 4) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.performSegueWithIdentifier("showSwiper", sender: self)
                        })
                    }
                    else {
                    
                    parseLogin()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier("showFavPicker", sender: self)
                    })
                    }
                }
            }

        } catch {
            fatalError("could not retrive user data \(error)")
        }
    }
    
    func parseLogin() {
        var user = PFUser()
        if let username = TMDBClient.sharedInstance().userID {
            
            // saveUserToCoreData(username)
            
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
    
    func parseSignUp() {
        var user = PFUser()
        if let username = TMDBClient.sharedInstance().userID {
            
           // saveUserToCoreData(username)
            
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
