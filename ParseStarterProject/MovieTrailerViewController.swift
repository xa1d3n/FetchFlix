//
//  MovieTrailerViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 11/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MovieTrailerViewController: UIViewController {
    @IBOutlet weak var player: UIWebView!
    var trailerKey : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        
        if let key = trailerKey {
            let url = "https://www.youtube.com/embed/\(key)"
            let htmlUrl = "<html><head><body style=\"(margin:0 auto)\"><embed id=\"yt\" src=\"\(url)\" type=\"application/x-shockwave-flash\"width=\"\(560)\" height=\"\(315)\"></embed> </body></html>"
            player.loadHTMLString(htmlUrl, baseURL: nil)
        }

        // Do any additional setup after loading the view.
        
      //  var url = "https://www.youtube.com/embed/yUEFauIpR40"
        
       // var htmlUrl = "<html><head><body style=\"(margin:0)\"><embed id=\"yt\" src=\"\(url)\" type=\"application/x-shockwave-flash\"width=\"\(560)\" height=\"\(315)\"></embed> </body></html>"
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
