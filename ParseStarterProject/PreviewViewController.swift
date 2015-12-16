//
//  PreviewViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var rating: CosmosView!
    var filmTitle : String!
    var posterImage : UIImage!
    var movieRating : Double!
    
    var previewActions : [UIPreviewActionItem] {
        let remove = UIPreviewAction(title: "Delete", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            
        }
        
        let favorite = UIPreviewAction(title: "Favorite", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            
        }
        
        return [remove, favorite]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        movieTitle.text = filmTitle
        poster.image = posterImage
        rating.rating = movieRating
    }
}
