//
//  MoleCollectionViewCell.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/17/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit

class MoleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var moleImageView: UIImageView!
    
    let moleImages = [#imageLiteral(resourceName: "mole_1"), #imageLiteral(resourceName: "mole_2")]
    
    let defaultHoleImage = #imageLiteral(resourceName: "mole-hole")
    
    var isMoleUp = false
    
    func isMoleUpStatus() -> Bool{
        return isMoleUp
    }
    
    func setMoleUp(){
        isMoleUp = true
        let moleImage = moleImages[Int(arc4random_uniform(UInt32(moleImages.count)))]
        moleImageView.image = moleImage
    }
    
    func isRedMole(image: UIImageView) -> Bool {
        if image.image == moleImages[1]{
            return true
        }
        return false
    }
    
    func setMoleDown(){
        isMoleUp = false
        moleImageView.image = defaultHoleImage
        
    }
}
