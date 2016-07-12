//
//  CoreData.swift
//  Realtor-App
//
//  Created by Daniel J Janiak on 7/8/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let model = "Home Report"
    
    /* Create a NSURL for the application document directory */
    private lazy var applicationDocumentsDirectory: NSURL = {
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urls[urls.count-1]
        
    }()
    
    /* Set the managed object model */
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = NSBundle.mainBundle().URLForResource(self.model, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
    }()
    
    /* Set the persistence store coordinator */
    private lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.model)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch {
            fatalError("Error adding persistence store")
        }
        
        return coordinator
        
    }()
    
    /* Set the managed object context */
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = self.persistenceStoreCoordinator
        
        return context
        
    }()
    
    // MARK: - Helpers
    func saveContext() {
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print("Error saving the model context")
                abort()
            }
        }
    }
    
    
}