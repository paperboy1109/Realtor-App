//
//  AppDelegate.swift
//  Realtor-App
//
//  Created by Daniel J Janiak on 7/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        deleteRecords()
        checkDataStore()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Helpers
    
    /* Does data already exist in the data store? */
    
    func checkDataStore() {
        
        let coreDataStack = CoreDataStack()
        
        let request = NSFetchRequest(entityName: "Home")
        
        // .init() deprecated in Swift 3
        //let homeCount = coreDataStack.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
        let homeCount = coreDataStack.managedObjectContext.countForFetchRequest(request, error: nil)
        
        print("The total home count is: ")
        print(homeCount)
        
        if homeCount == 0 {
            /* Chose one or the other data source */
            //uploadSampleDataFromJSON()
            uploadSampleDataFromPlist()
        }
        
    }
    
    func uploadSampleDataFromJSON() {
        
        let coreDataStack = CoreDataStack()
        
        let url = NSBundle.mainBundle().URLForResource("sample", withExtension: "json")
        
        let data = NSData(contentsOfURL: url!)
        
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let resultArray = result.valueForKey("home") as! NSArray
            
            /* Build the data model entities */
            for item in resultArray {
                
                let home = NSEntityDescription.insertNewObjectForEntityForName("Home", inManagedObjectContext: coreDataStack.managedObjectContext) as! Home
                
                home.county = item["county"] as? String
                home.price = item["price"] as? NSNumber
                home.bed = item["bed"] as? NSNumber
                home.bath = item["bath"] as? NSNumber
                home.sqft = item["sqft"] as? NSNumber
                
                let category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: coreDataStack.managedObjectContext) as! Category
                category.homeType = (item["category"] as! NSDictionary)["homeType"] as? String
                home.category = category
                
                let status = NSEntityDescription.insertNewObjectForEntityForName("Status", inManagedObjectContext: coreDataStack.managedObjectContext) as! Status
                let isForSale = (item["status"] as! NSDictionary)["isForSale"] as! Bool
                status.isForSale = NSNumber(bool: isForSale)
                home.status = status
                
                let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: coreDataStack.managedObjectContext) as! Location
                location.city = item["city"] as? String
                home.location = location
                
                let imageName = item["image"] as? String
                let image = UIImage(named: imageName!)
                let imageData = UIImageJPEGRepresentation(image!, 1.0)
                home.image = imageData
                
            }
            
            coreDataStack.saveContext()
            
            /* Check that entities are not empty */
            let request = NSFetchRequest(entityName: "Home")
            let homeCount = coreDataStack.managedObjectContext.countForFetchRequest(request, error: nil)
            print("The total home count after trying to load sample data is: ")
            print(homeCount)
            
        } catch {
            fatalError("Error parsing JSON sample data")
        }
    }
    
    func uploadSampleDataFromPlist() {
        
        let coreDataStack = CoreDataStack()
        
        let path = NSBundle.mainBundle().pathForResource("sample", ofType: "plist")
        
        let resultArray = NSArray(contentsOfFile: path!)!
        
        /* Build the data model entities */
        for item in resultArray {
            
            let home = NSEntityDescription.insertNewObjectForEntityForName("Home", inManagedObjectContext: coreDataStack.managedObjectContext) as! Home
            
            home.county = item["county"] as? String
            home.price = item["price"] as? NSNumber
            home.bed = item["bed"] as? NSNumber
            home.bath = item["bath"] as? NSNumber
            home.sqft = item["sqft"] as? NSNumber
            
            let category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: coreDataStack.managedObjectContext) as! Category
            category.homeType = (item["category"] as! NSDictionary)["homeType"] as? String
            home.category = category
            
            let status = NSEntityDescription.insertNewObjectForEntityForName("Status", inManagedObjectContext: coreDataStack.managedObjectContext) as! Status
            let isForSale = (item["status"] as! NSDictionary)["isForSale"] as! Bool
            status.isForSale = NSNumber(bool: isForSale)
            home.status = status
            
            let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: coreDataStack.managedObjectContext) as! Location
            location.city = item["city"] as? String
            home.location = location
            
            let imageName = item["image"] as? String
            let image = UIImage(named: imageName!)
            let imageData = UIImageJPEGRepresentation(image!, 1.0)
            home.image = imageData
            
        }
        
        coreDataStack.saveContext()
        
        /* Check that entities are not empty */
        let request = NSFetchRequest(entityName: "Home")
        let homeCount = coreDataStack.managedObjectContext.countForFetchRequest(request, error: nil)
        print("The total home count after trying to load sample data is: ")
        print(homeCount)
        
    }
    
    func deleteRecords() {
        let coreDataStack = CoreDataStack()
        let homeRequest = NSFetchRequest(entityName: "Home")
        let categoryRequest = NSFetchRequest(entityName: "Category")
        let statusRequest = NSFetchRequest(entityName: "Status")
        let locationRequest = NSFetchRequest(entityName: "Location")
        
        do {
            let homeResults = try coreDataStack.managedObjectContext.executeFetchRequest(homeRequest) as! [Home]
            for home in homeResults {
                coreDataStack.managedObjectContext.deleteObject(home)
            }
            
            let categoryResults = try coreDataStack.managedObjectContext.executeFetchRequest(categoryRequest) as NSArray
            for category in categoryResults {
                coreDataStack.managedObjectContext.deleteObject(category as! NSManagedObject)
            }
            
            let statusResults = try coreDataStack.managedObjectContext.executeFetchRequest(statusRequest) as! [Status]
            for status in statusResults {
                coreDataStack.managedObjectContext.deleteObject(status)
            }
            
            let locationResults = try coreDataStack.managedObjectContext.executeFetchRequest(locationRequest) as! [Location]
            for location in locationResults {
                coreDataStack.managedObjectContext.deleteObject(location)
            }
            
            coreDataStack.saveContext()
            
            // the .init() approach is deprecated in Swift 3
            let homeCount = coreDataStack.managedObjectContext.countForFetchRequest(homeRequest, error: nil) //(homeRequest, error: NSErrorPointer.init())
            print("Total home after clean up: \(homeCount)")
        }
        catch {
            fatalError("Error deleting objects")
        }
    }
    
    
    
    
}

