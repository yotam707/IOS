//
//  ViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/9/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var activeMoles: [[Int]] = []
    var cells: [[Int]] = []
    
    
    
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var hitsValueLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var missesLabelValue: UILabel!
    
    @IBOutlet weak var gameDataView: UIView!
    
    var currentScoreValue = 0
    var currentHitsValue = 0
    var numOfRows = 4
    var numOfCols = 4
    fileprivate let itemsPerRow: CGFloat = 4
    var moleLevel: MoleLevel!
    var numOfMisses = 0
    var numOfMoles = 0
    var seconds = 120
    var timer = Timer()
    var isTimerRunning = false
    var gameFinished = false
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 5.0)
    
    
    func createCells(){
        for row in 0..<numOfRows{
            for col in 0..<numOfCols{
                cells.append([row,col])
            }
        }
    }
    
    func runTimer(){
        seconds = Int(120 * (Float(2)/Float(moleLevel.rawValue)))
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Double(Float(2)/Float(moleLevel.rawValue))), target: self, selector: (#selector(ViewController.runGame)), userInfo: nil, repeats: true)
    }
    
    func runGame(){
        updateTimer()
        if !gameFinished {
        let cell = getEmptyMoleCell()
        cell.setMoleUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3/moleLevel.rawValue), execute: { [weak self] in
            guard let strongSelf = self else { return }
            if cell.isMoleUpStatus(){
                if !cell.isRedMole(image: cell.moleImageView){
                    strongSelf.missMole()
                }
            cell.setMoleDown()
            }
        })
        }
        else{
            return
        }
        
    }
    //need to fix this when array is empty
    func getEmptyMoleCell() -> MoleCollectionViewCell{
        numOfMoles = Int(arc4random_uniform(UInt32(cells.count)))
        if cells.count <= 0{
            popFromUsedCells()
        }
        cells.shuffle()
        let cellIndex = cells.removeFirst()
        
        let cell = collectionView.cellForItem(at: IndexPath(row: cellIndex[0],section: cellIndex[1])) as! MoleCollectionViewCell
        
        if !cell.isMoleUpStatus(){
            addToUsedCells(cellIndex: cellIndex)
            return cell
        }
        else{
            removeFromUsedCells(cellIndex: cellIndex)
        }
        return getEmptyMoleCell()
    }
    
    
    func removeFromUsedCells(cellIndex:[Int]){
        if let indexC = activeMoles.index(where: { $0 == cellIndex }){
            let cellIndex = activeMoles.remove(at: indexC)
            addToMoleCells(cellIndex: cellIndex)
        }
    }
    
    func popFromUsedCells(){
        for index in activeMoles{
            addToMoleCells(cellIndex: index)
        }
        let cellIndex = activeMoles.removeLast()
        addToMoleCells(cellIndex: cellIndex)
    }
    
    func addToMoleCells(cellIndex: [Int]){
        cells.append(cellIndex)
    }
    
    func addToUsedCells(cellIndex: [Int]){
        activeMoles.append(cellIndex)
    }
    
    func updateTimer(){
        if seconds < 1{
            timer.invalidate()
            return
        } else{
            seconds -= 1
            timerValueLabel.text = timerString(time: TimeInterval(seconds))
        }
    }
    
    func timerString(time:TimeInterval) -> String{
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionView!.register(MoleCollectionViewCell.self , forCellWithReuseIdentifier: "MoleCollectionViewCell")
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        gameDataView.layer.cornerRadius = 5
        gameDataView.layer.borderWidth = 3
        gameDataView.layer.borderColor = UIColor.brown.cgColor
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //collectionView.backgroundColor = UIColor(white: 1, alpha: 1)
        createCells()
        startGame()
    }
    
    func initilizeView(){
        updateLabels()
    }
    
    func startGame(){
        runTimer()
    }
    
    func updateLabels(){
        updateScore()
        updateHits()
    }
    
    
    func missMole(){
        
        numOfMisses += 1
        missesLabelValue.text = "\(numOfMisses)"
        if numOfMisses == 3 {
            finishGame(win: false)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moleCell = collectionView.cellForItem(at: indexPath) as! MoleCollectionViewCell
        
        if moleCell.isMoleUpStatus(){
            if !moleCell.isRedMole(image: moleCell.moleImageView){
                moleCell.playPunchMusic()
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
        updateLabels()
        if currentHitsValue == 30 {
            finishGame(win: true)
        }
    }
    
    func hitMoleDown(){
        if currentScoreValue > 0{
            currentScoreValue -= moleLevel.rawValue * 10
            if currentScoreValue < 0{
                currentScoreValue = 0
            }
        }
        if currentHitsValue > 0{
            currentHitsValue -= 1
        }
        updateLabels()
    }


    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView?.collectionViewLayout.invalidateLayout()
     
    }
    
    func finishGame(win: Bool){
        
        gameFinished = true
        var alertMsg: UIAlertController!
        
        if win {
            alertMsg = UIAlertController(title: "You Win mofo", message: "\(currentHitsValue) hits, you win", preferredStyle: UIAlertControllerStyle.alert)
        }
        else{
            alertMsg = UIAlertController(title: "You Lose mofo", message: "\(currentHitsValue) hits were made", preferredStyle: UIAlertControllerStyle.alert)
        }
        
        alertMsg.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in self.dismiss(animated: true, completion: nil)}))
        
        present(alertMsg, animated: true, completion: nil)
        
    }
    
    
    func updateHits(){
        hitsValueLabel.text = "\(currentHitsValue)"
    }
    
    func updateScore(){
        scoreValueLabel.text = "\(currentScoreValue)"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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


