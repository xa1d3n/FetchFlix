//
//  MenuTableViewController.swift
//  Filmr
//
//  Created by Aldin Fajic on 12/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreData

class MenuTableViewController: UITableViewController {
    
    let moc = DataController().managedObjectContext
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == 2 {
            logoutUser()
        }
    }
    
    func logoutUser() {
        //getUSerFromCoreData()
        
        
    }
    
    func getUSerFromCoreData() {
        let userFetch = NSFetchRequest(entityName: "User")
        
        do {
            let fetchedUser = try moc.executeFetchRequest(userFetch) as! [User]
            if let user = fetchedUser.first {
                self.user = user
                
                self.user?.sessionID
                //favMovie!.setValue(title, forKey: "title")
                self.user?.setValue("", forKey: "sessionID")
                do {
                    try moc.save()
                    self.performSegueWithIdentifier("logout", sender: self)
                } catch {
                    fatalError("failure to save context: \(error)")
                }
            }
            
        } catch {
            fatalError("could not retrive user data \(error)")
        }
    }

}
