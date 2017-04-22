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
    let cells: [[Int]] = [[0,1],[0,2],[0,3],[1,1],[1,2],[1,3],[2,1],[2,2],[2,3]]
    
    
    
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var hitsValueLabel: UILabel!
    
    var currentScoreValue = 0
    var currentHitsValue = 0
    var numOfRows = 3
    var numOfCols = 3
    var moleLevel: MoleLevel!
    var seconds = 120
    var timer = Timer()
    var isTimerRunning = false
    
    
    func runTimer(){
        seconds = Int(120 * (Float(2)/Float(moleLevel.rawValue)))
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Double(Float(2)/Float(moleLevel.rawValue))), target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
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
        self.collectionView!.register(MoleCollectionViewCell.self , forCellWithReuseIdentifier: "MoleCollectionViewCell")
        
        
        
        
            // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGame()
    }
    
    func initilizeView(){
        scoreValueLabel.text = "\(currentScoreValue)"
        hitsValueLabel.text = "\(currentHitsValue)"
    }
    
    func startGame(){
        runTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moleCell = collectionView.cellForItem(at: indexPath) as! MoleCollectionViewCell
        
        if moleCell.isMoleUpStatus(){
            if moleCell.moleImageView == moleCell.moleImages[0]{
                hitMoleUp()
            }
            else{
                hitMoleDown()
            }
            moleCell.setMoleDown()
        }
        
    }
    
    func hitMoleUp(){
        currentScoreValue += moleLevel.rawValue * 10
        currentHitsValue += 1
        if currentHitsValue == 30 {
            finishGame(win: true)
        }
    }
    
    func finishGame(win: Bool){
        var alertMsg: UIAlertController!
        
        if win {
            alertMsg = UIAlertController(title: "You Win mofo", message: "\(currentHitsValue) hits, you win", preferredStyle: UIAlertControllerStyle.alert)
        }
        else{
            alertMsg = UIAlertController(title: "You Lose mofo", message: "\(currentHitsValue) hits were made", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        alertMsg.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in self.performSegue(withIdentifier: "backToMainSague", sender: self) }))
        
        present(alertMsg, animated: true, completion: nil)
        
    }
    
    func hitMoleDown(){
        if currentScoreValue > 0{
            currentScoreValue -= 1
        }
        if currentHitsValue > 0{
            currentHitsValue -= moleLevel.rawValue * 10
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numOfRows
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCols
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoleCollectionViewCell", for: indexPath) as! MoleCollectionViewCell
        
        
        return cell
    }
    
}


