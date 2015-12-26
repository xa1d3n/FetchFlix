//
//  FanTVViewController.swift
//  FetchFlix
//
//  Created by Aldin Fajic on 12/25/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class FanTVViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar.tintColor = UIColor.redColor()
        var urlString = TMDBClient.Constants.FanTVURL
        
        if let id = id {
            urlString = TMDBClient.Constants.FanTVURL + "/movies/\(id)"
        }
        let url = NSURL (string: urlString);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj)
    }
    @IBAction func exit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
