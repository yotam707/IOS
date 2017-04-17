//
//  Mole.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/16/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import Foundation
class Mole {
    var hit: Bool = false
    var image: String = ""
    var id: String = ""
    
    
    init(id: String, image: String, hit: Bool = false) {
        self.id = id
        self.image = image
        self.hit = hit
    }
    
    
}
