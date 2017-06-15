//
//  WhackLocalUserData.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/15/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import Foundation

class WhackLocalUserData {
    var firstName: String?
    var lastName: String?
    var gameLevel: Int?
    var score: Int?
    var dateTime: Date?
    var long: String?
    var lati: String?
    
    init(firstName: String, lastName: String, dateTime: Date, long: String, lati: String){
        self.firstName = firstName
        self.lastName = lastName
        self.dateTime = dateTime
        self.long = long
        self.lati = lati
    }
    
    
}
