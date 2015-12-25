//
//  MovieTrailerViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MovieTrailerViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var player: UIWebView!
    var trailerKey : String?
    
    var spinner : UIActivityIndicatorView?

    @IBOutlet weak var noTrailer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        player.delegate = self
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        spinner = HelperFunctions.startSpinner(self.view)
        // get movie trailer from youtube. Show empty lable if not available.
        if let key = trailerKey {
            let url = "https://www.youtube.com/embed/\(key)"
            let htmlUrl = "<html><head><body style=\"(margin:0 auto)\"><embed id=\"yt\" src=\"\(url)\" type=\"application/x-shockwave-flash\"width=\"\(560)\" height=\"\(315)\"></embed> </body></html>"
            player.loadHTMLString(htmlUrl, baseURL: nil)
        }
        else {
            noTrailer.hidden = false
            HelperFunctions.stopSpinner(spinner!)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        HelperFunctions.stopSpinner(spinner!)
    }
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if let error = error {
            self.presentViewController(HelperFunctions.showAlert(error), animated: true, completion: nil)
        }
        HelperFunctions.stopSpinner(spinner!)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
