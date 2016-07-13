//
//  SummaryVC.swift
//  Realtor-App
//
//  Created by Daniel J Janiak on 7/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import CoreData

class SummaryVC: UITableViewController {
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext!
    
    var soldPredicate: NSPredicate!
    
    // MARK: - Outlets
    
    @IBOutlet weak var townhomeSoldLabel: UILabel!
    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var sfHomeSoldLabel: UILabel!
    @IBOutlet weak var minPriceHomeLabel: UILabel!
    @IBOutlet weak var maxPriceHomeLabel: UILabel!
    @IBOutlet weak var avgPriceTownhomeLabel: UILabel!
    @IBOutlet weak var avgPriceSFHomeLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soldPredicate = NSPredicate(format: "status.isForSale = false")
        
        getTotalHomeSales()
        getTotalTownhomesSold()
        getTotalSingleFamilyHomesSold()
        getSalePriceByType("min")
        getSalePriceByType("max")
        getAveHomePrice("Townhome")
        getAveHomePrice("Single Family")
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
    
    func getSalePriceByType(priceType: String) {
        
        let fetchRequest = NSFetchRequest(entityName: "Home")
        fetchRequest.predicate = soldPredicate
        fetchRequest.resultType = .DictionaryResultType
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = priceType
        expressionDescription.expression = NSExpression(forFunction: "\(priceType):", arguments: [NSExpression(forKeyPath: "price")])
        expressionDescription.expressionResultType = .DoubleAttributeType
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSDictionary]
            let dictionary = results.first!
            let homePrice = dictionary[priceType] as! NSNumber
            
            if priceType == "min" {
                minPriceHomeLabel.text = stringFromNSNumber(homePrice)
            } else {
                maxPriceHomeLabel.text = stringFromNSNumber(homePrice)
            }
            
        } catch {
            fatalError("Error in getting \(priceType) home sales")
        }
    }
    
    func getAveHomePrice(homeType: String) {
        
        let typePredicate = NSPredicate(format: "category.homeType = %@", homeType)
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType , subpredicates: [soldPredicate, typePredicate])
        
        let fetchRequest = NSFetchRequest(entityName: "Home")
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .DictionaryResultType
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = homeType
        expressionDescription.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "price")])
        expressionDescription.expressionResultType = .DoubleAttributeType
        
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSDictionary]
            let dictionary = results.first!
            let homePrice = dictionary[homeType] as! NSNumber
            
            if homeType == "Townhome" {
                avgPriceTownhomeLabel.text = stringFromNSNumber(homePrice)
            } else {
                avgPriceSFHomeLabel.text = stringFromNSNumber(homePrice)
            }
            
        } catch {
            fatalError("Error in getting average \(homeType) price")
        }
    }
    
    func getTotalTownhomesSold() {
        
        let typePredicate = NSPredicate(format: "category.homeType = 'Townhome' ")
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType , subpredicates: [soldPredicate, typePredicate])
        
        let fetchRequest = NSFetchRequest(entityName: "Home")
        fetchRequest.resultType = .CountResultType
        fetchRequest.predicate = predicate
        
        var count: NSNumber!
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSNumber]
            count = results.first
        } catch {
            fatalError("Failed to get the total count of townhomes sold")
        }
        
        townhomeSoldLabel.text = count.stringValue
    }
    
    func getTotalSingleFamilyHomesSold() {
        
        let typePredicate = NSPredicate(format: "category.homeType = 'Single Family' ")
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType , subpredicates: [soldPredicate, typePredicate])
        
        let fetchRequest = NSFetchRequest(entityName: "Home")
        fetchRequest.predicate = predicate
        
        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
        
        if count != NSNotFound {
            sfHomeSoldLabel.text = String(count)
        } else {
            fatalError("Failed to get the total count of single family homes sold")
        }
        
    }
    
    func getTotalHomeSales() {
        let fetchRequest = NSFetchRequest(entityName: "Home")
        fetchRequest.predicate = soldPredicate
        fetchRequest.resultType = .DictionaryResultType
        
        /* Use a CoreData aggregate function to total up home sales */
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "totalSales"
        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "price")])
        sumExpressionDescription.expressionResultType = .DoubleAttributeType
        
        fetchRequest.propertiesToFetch = [sumExpressionDescription]
        
        do {
            
            let results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSDictionary]
            let dictionary = results.first!
            let totalSales = dictionary["totalSales"] as! NSNumber
            
            totalSalesLabel.text = stringFromNSNumber(totalSales)
            
        } catch {
            fatalError("Failed to get total home sales")
        }
    }
    
    func stringFromNSNumber(numberToFormat: NSNumber) -> String {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        let formattedString = formatter.stringFromNumber(numberToFormat)
        
        return formattedString!
        
    }
    
}


extension SummaryVC {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        
        switch section {
        case 0:
            rowCount = 3
        case 1, 2:
            rowCount = 2
        default:
            rowCount = 0
        }
        
        return rowCount
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    } */
}
