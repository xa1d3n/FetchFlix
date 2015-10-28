//
//  MovieDetailPageViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 10/24/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class MovieDetailPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var index = 0
    var identifiers = ["MovieDetailViewController", "MovieInfoController"]
    var viewControlls = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        

        //self.viewC
        
        let startingView = viewControllerAtIndex(index)
        viewControlls = [startingView]
        self.setViewControllers(viewControlls, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
       let ind =  identifiers[index]
        return (self.storyboard?.instantiateViewControllerWithIdentifier(ind))! as UIViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! UIViewController
        var identifier = vc.restorationIdentifier
        var ind = self.identifiers.indexOf(identifier!)
        
        if (ind == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if (index >= self.identifiers.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let identifier = viewController.restorationIdentifier
        var ind = self.identifiers.indexOf(identifier!)
        
        if (ind == NSNotFound || ind <= 0)
        {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
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
