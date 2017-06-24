//
//  WinnerAnootationPin.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/24/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class WinnerAnootationPin: NSObject, MKAnnotation {

    var title: String?
    var subtitle: String?
    var myCoordinate: CLLocationCoordinate2D
    
    var coordinate: CLLocationCoordinate2D {
        return myCoordinate
    }
    
    init(title: String , subtitle: String , myCoordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.myCoordinate = myCoordinate
    }
}
