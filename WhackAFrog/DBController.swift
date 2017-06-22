//
//  DBController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/1/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBController {
    
    
    private init(){
        
    }
    
    
    class func getContext()-> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func setUserDetails(_ value: WhckAFrogGameUser, keyVal: String){
        UserDefaults.standard.set(value.firstName, forKey: GlobalConstants.gameFirstName)
        UserDefaults.standard.set(value.lastName, forKey: GlobalConstants.gameLastName)
        UserDefaults.standard.set(value.longitude, forKey: GlobalConstants.userLongitude)
        UserDefaults.standard.set(value.latitude, forKey: GlobalConstants.userLatitude)
        UserDefaults.standard.set(value.score, forKey: GlobalConstants.userScore)
        UserDefaults.standard.set(value.gameLevel, forKey: GlobalConstants.gameLevel)
        UserDefaults.standard.set(Date(), forKey: GlobalConstants.userTime)
    }
    
    static func getUsetDetails() -> WhackLocalUserData{
        let whackUser =  WhackLocalUserData(firstName: UserDefaults.standard.string(forKey: GlobalConstants.gameFirstName)!, lastName: UserDefaults.standard.string(forKey: GlobalConstants.gameLastName)!, dateTime: UserDefaults.standard.object(forKey: GlobalConstants.userTime) as! Date, long: UserDefaults.standard.string(forKey: GlobalConstants.userLongitude)!, lati: UserDefaults.standard.string(forKey: GlobalConstants.userLatitude)!)
        
        return whackUser
    }
    
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WhackAFrog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

    
    
}
