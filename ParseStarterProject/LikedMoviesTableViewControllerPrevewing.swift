//
//  LikedMoviesTableViewControllerPrevewing.swift
//  Filmr
//
//  Created by Aldin Fajic on 12/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

extension LikedMoviesTableViewController: UIViewControllerPreviewingDelegate {

    //peek
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = self.tableView.indexPathForRowAtPoint(location),
            cell = self.tableView.cellForRowAtIndexPath(indexPath) else {
                return nil
        }
        
        guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("PreviewVC") as? PreviewViewController else { return nil }

        if (searchActive  && filtered.count > 0) {
            previewVC.filmTitle = filtered[indexPath.row].title
            previewVC.posterImage = cell.imageView?.image
            previewVC.movieRating = Double((filtered[indexPath.row].rating)!)
            previewVC.movie = movies[indexPath.row]
            selectedMovie = filtered[indexPath.row]
        }
        else {
            previewVC.filmTitle = movies[indexPath.row].title
            previewVC.posterImage = cell.imageView?.image
            previewVC.movieRating = Double((movies[indexPath.row].rating)!)
            previewVC.movie = movies[indexPath.row]
            selectedMovie = movies[indexPath.row]
        }
        previewVC.presentingVC = self
        previewVC.moc = moc
        previewVC.user = user
        previewVC.preferredContentSize = CGSize(width: 0, height: 400)
        previewingContext.sourceRect = cell.frame
        
        
        
        return previewVC
    }
    
    // pop
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieRatingViewController") as! MovieRatingViewController
            controller.movie = selectedMovie
            controller.moc = moc
            controller.user = user
        navigationController?.pushViewController(controller, animated: true)
    }
}
