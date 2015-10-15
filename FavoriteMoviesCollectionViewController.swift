//
//  FavoriteMoviesCollectionViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class FavoriteMoviesCollectionViewController: UICollectionViewController {
    
    var posters = [UIImage?](count: 3, repeatedValue: nil)
    var posterInd : Int? = nil
    var movieTitles = [String?](count: 3, repeatedValue: nil)
    
    var movieIds = [Int?](count: 3, repeatedValue: nil)
    var posterImage: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes

        // Do any additional setup after loading the view.
        
        /*TMDBClient.sharedInstance().getSimilarMovies(17169) { (result, error) -> Void in
            if let movies = result {
                print(movies.count)
                for movie in movies {
                    print(movie.title)
                }
            }
        } */
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        for title in movieTitles {
            print(title)
        }
        if let posterImage = posterImage {
            TMDBClient.sharedInstance().taskForGetImage(TMDBClient.ParameterKeys.posterSizes[3], filePath: posterImage, completionHandler: { (imageData, error) -> Void in
                if let image = UIImage(data: imageData!) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.posters[self.posterInd!] = image
                        
                        var isNil = false
                        for pstr in self.posters {
                            if pstr == nil {
                                isNil = true
                            }
                        }
                        
                        if isNil == false {
                            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                        
                        self.collectionView?.reloadData()
                    })
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MoviePosterCollectionViewCell
        
        if let poster = posters[indexPath.row] {
            cell.poster.image = poster
        }
        else {
            let image = UIImage(named: "Add")
            cell.poster.image = image
        }
        
        
        
        
        cell.title.text = movieTitles[indexPath.row]
        
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        posterInd = indexPath.row
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MoviePickerViewController") as! MoviePickerViewController
        controller.posters = posters
        controller.posterInd = posterInd
        controller.movieIds = movieIds
        controller.movieTitles = movieTitles
        self.navigationController!.pushViewController(controller, animated: true)
    }

}
