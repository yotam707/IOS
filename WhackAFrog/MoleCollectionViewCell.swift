//
//  MoleCollectionViewCell.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/17/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import AVFoundation

class MoleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var moleImageView: UIImageView!
    
    let moleImages = [#imageLiteral(resourceName: "mole_1"), #imageLiteral(resourceName: "mole_2")]
    
    let defaultHoleImage = #imageLiteral(resourceName: "mole-hole")
    
    var isMoleUp = false
    
    var audioPlayer = AVAudioPlayer()
    
    
    
    func isMoleUpStatus() -> Bool{
        return isMoleUp
    }
    
    func setMoleUp(){
        isMoleUp = true
        let moleImage = moleImages[Int(arc4random_uniform(UInt32(moleImages.count)))]
        UIView.transition(with: self.contentView, duration: 0.7, options: UIViewAnimationOptions.transitionFlipFromBottom, animations:
            {
                self.moleImageView.image = moleImage
        }, completion: {finished in
            
        })
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
        //moleImageView.image = defaultHoleImage
        UIView.transition(with: self.contentView, duration: 0.7, options: UIViewAnimationOptions.transitionFlipFromTop, animations:
            {
                self.moleImageView.image = self.defaultHoleImage
        }, completion: {finished in
        
        })
        
    }
    
    
    func playPunchMusic(){
        do{
            let punchSound = URL(fileURLWithPath: Bundle.main.path(forResource: "punch", ofType: "mp3")!)
            self.audioPlayer = try AVAudioPlayer(contentsOf: punchSound)
            self.audioPlayer.numberOfLoops = 1
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        }
        catch{
            print("paunch.mp3 can't be played")
        }
    }
    
    
    func stopFromMusic(){
        self.audioPlayer.stop()
    }
}
