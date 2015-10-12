//
//  LoginViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
                
            }
            else {
                print("auth error bitch")
            }
        }
    }

}
