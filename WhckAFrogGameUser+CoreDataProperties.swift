//
//  WhckAFrogGameUser+CoreDataProperties.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/1/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import Foundation
import CoreData


extension WhckAFrogGameUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WhckAFrogGameUser> {
        return NSFetchRequest<WhckAFrogGameUser>(entityName: "GameUser")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var gameLevel: String?
    @NSManaged public var id: Int32
    @NSManaged public var lastName: String?
    @NSManaged public var misses: Int32
    @NSManaged public var score: Int32

}
