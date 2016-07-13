//
//  FilterTableVC.swift
//  Realtor-App
//
//  Created by Daniel J Janiak on 7/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

protocol FilterTableVCDelegate: class {
    func updateHomeList(filterBy: NSPredicate?, sortBy: NSSortDescriptor?)
}

class FilterTableVC: UITableViewController {
    
    // MARK: - Properties
    var sortDescriptor: NSSortDescriptor?
    var searchPredicate: NSPredicate?
    var delegate: FilterTableVCDelegate!
    
    
    // MARK: - Outlets
    
    @IBOutlet var sortByLocationCell: UITableViewCell!
    @IBOutlet var sortByPriceLowHighCell: UITableViewCell!
    @IBOutlet var sortByPriceHighLowCell: UITableViewCell!
    
    @IBOutlet var filterByTownhomeCell: UITableViewCell!
    @IBOutlet var filterBySingleFamilyCell: UITableViewCell!
    
    
    // MARK: - Lifecycle
    
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
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        } else {
            return 0
        }
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /* Capture the user's selection */
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        switch selectedCell {
            
            // Sort
            
        case sortByLocationCell:
            setSortDescriptor("location.city", isAscending: true)
            
        case sortByPriceLowHighCell:
            setSortDescriptor("price", isAscending: true)
            
        case sortByPriceHighLowCell:
            setSortDescriptor("price", isAscending: false)
            
            // Filter
            
        case filterByTownhomeCell:
            setFilterSearchPredicate("Townhome")
            
        case filterBySingleFamilyCell:
            setFilterSearchPredicate("Single Family")
            
        default:
            print("No cell has been selected")
        }
        
        selectedCell.accessoryType = .Checkmark
        
        /* Let the deligate know about any sorting and filtering selected */
        delegate.updateHomeList(searchPredicate, sortBy: sortDescriptor)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Helpers
    
    func setSortDescriptor(sortBy: String, isAscending: Bool) {
        sortDescriptor = NSSortDescriptor(key: sortBy, ascending: isAscending)
    }
    
    func setFilterSearchPredicate(filterBy: String) {
        searchPredicate = NSPredicate(format: "category.homeType = %@", filterBy)
    }
    
}
