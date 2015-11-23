/**

* Copyright (c) 2015-present, Parse, LLC.

* All rights reserved.

*

* This source code is licensed under the BSD-style license found in the

* LICENSE file in the root directory of this source tree. An additional grant

* of patent rights can be found in the PATENTS file in the same directory.

*/



import UIKit

import Parse


class FavoriteMoviesViewController: UIViewController {
    
    @IBOutlet weak var favOne: UIButton!
    @IBOutlet weak var favTwo: UIButton!
    @IBOutlet weak var favThree: UIButton!
    
    var posters = [UIImage?](count: 3, repeatedValue: nil)
    var posterInd : Int? = nil
    
    var movieIds = [Int?](count: 3, repeatedValue: nil)
    var posterImage: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if let posterImage = posterImage {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[3], filePath: posterImage, completionHandler: { (imageData, error) -> Void in
                //print(imageData)
                //print(error)
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.posters[self.posterInd!] = image
                        
                        let buttons = [self.favOne, self.favTwo, self.favThree]
                        var index = 0
                        
                        for poster in self.posters {
                            buttons[index].setBackgroundImage(poster, forState: UIControlState.Normal)
                            
                            index++
                        }
                        self.posterImage = nil
                    })
                }
            })
        }
        
    }
    
    @IBAction func firstFav(sender: AnyObject) {
        posterInd = 0
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MoviePickerViewController") as! MoviePickerViewController
        controller.posters = posters
        controller.posterInd = posterInd
        controller.movieIds = movieIds
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
    
    
    @IBAction func secondFav(sender: AnyObject) {
        posterInd = 1
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MoviePickerViewController") as! MoviePickerViewController
        controller.posters = posters
        controller.posterInd = posterInd
        controller.movieIds = movieIds
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func thirdFav(sender: AnyObject) {
        posterInd = 2
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MoviePickerViewController") as! MoviePickerViewController
        controller.posters = posters
        controller.posterInd = posterInd
        controller.movieIds = movieIds
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
}

