//
//  ViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/9/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var moles: [Mole] = []
    
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var hitsValueLabel: UILabel!
    
    
    var moleLevel: MoleLevel!
    
    var seconds = 120
    var timer = Timer()
    var isTimerRunning = false
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer(){
        if seconds < 1{
            timer.invalidate()
        } else{
            seconds -= 1
            timerValueLabel.text = timerString(time: TimeInterval(seconds))
        }
    }
    
    func timerString(time:TimeInterval) -> String{
        let minuets = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minuets, seconds)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startGame()
    }
    
    func startGame(){
        runTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
        return cell
    }

}


