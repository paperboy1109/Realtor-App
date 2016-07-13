//
//  HomeListVC.swift
//  Realtor-App
//
//  Created by Daniel J Janiak on 7/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import CoreData

class HomeListVC: UIViewController {
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext!
    var homes: [Home] = []    
    var isForSale: Bool = true
    
    var fetchRequest: NSFetchRequest!
    
    var sortDescriptor = [NSSortDescriptor]()
    var searchPredicate: NSPredicate?
    
    // MARK: - Outlets
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRequest = NSFetchRequest(entityName: "Home")
        
        loadData()
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControlTapped(sender: UISegmentedControl) {
        
        let selectedValue = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        
        isForSale = selectedValue == "For Sale" ? true: false
        
        loadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToFilter" {
            
            /* Reset the filters */
            sortDescriptor = []
            searchPredicate = nil
            
            let viewController = segue.destinationViewController as! FilterTableVC
            viewController.delegate = self
        }
    }
    
    // MARK: - Helpers
    
    func loadData() {
        
//        let fetchRequest = NSFetchRequest(entityName: "Home")
//        fetchRequest.predicate = NSPredicate(format: "status.isForSale = %@", isForSale)
        
        /* Allow filters to be applied */
        
        // Build the predicates
        var subPredicates = [NSPredicate]()
        let statusPredicate = NSPredicate(format: "status.isForSale = %@", isForSale)
        subPredicates.append(statusPredicate)
        if let additionalPredicates = searchPredicate {
            subPredicates.append(additionalPredicates)
        }
        
        // Make use of NSCompoundPredicate
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: subPredicates)
        
        fetchRequest.predicate = predicate
        
        /* Take sorting into account */
        
        if sortDescriptor.count > 0 {
            fetchRequest.sortDescriptors = sortDescriptor
        }
        
        do {
            homes = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Home]
            self.tableView.reloadData()
        } catch {
            fatalError("Failed to get an array of Homes where status isForSale")
        }
    }
    
    
}

extension HomeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("homeListTableCell", forIndexPath: indexPath) as! HomeListTableViewCell
        
        let home = homes[indexPath.row]
        
        let category = home.category
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        // Configure the cell...
        
        cell.cityLabel.text = home.location?.city
        cell.categoryLabel.text = category?.homeType
        cell.priceValueLabel.text = formatter.stringFromNumber(home.price!)
        cell.bedValueLabel.text = home.bed?.stringValue
        cell.bathValueLabel.text = home.bath?.stringValue
        cell.sqftValueLabel.text = home.sqft?.stringValue
        
        let image = UIImage(data: home.image!)
        cell.homeImageView.image = image
        
        // TODO: Consider moving this view customization to the custom cell class
        cell.homeImageView.layer.borderWidth = 1
        cell.homeImageView.layer.cornerRadius = 4
        
        
        return cell
    }
    

    
    
}




extension HomeListVC: FilterTableVCDelegate {
    func updateHomeList(filterBy: NSPredicate?, sortBy: NSSortDescriptor?) {
        
        // The filter applies to a total of two, mutually-exclusive groups so there is only one T/F property needed
        if let filter = filterBy {
            searchPredicate = filter
        }
        
        // Sorting can have multiple criteria at once, e.g. price and location, hence the array
        if let sort = sortBy {
            sortDescriptor.append(sort)
        }
    }
}
