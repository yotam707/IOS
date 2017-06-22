//
//  ViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/9/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var activeMoles: [[Int]] = []
    var cells: [[Int]] = []
    
    
    
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var hitsValueLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var missesLabelValue: UILabel!
    @IBOutlet weak var shakenNumLabel : UILabel!
    
    @IBOutlet weak var gameDataView: UIView!
    
    var currentScoreValue = 0
    var currentHitsValue = 0
    var numOfRows = 0
    var numOfCols = 0
    var moleLevel: MoleLevel!
    var numOfMisses = 0
    var numOfMoles = 0
    var seconds = 60
    var numOfShakes = 0
    var addShakeTime = 0
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
        seconds = 60
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Double(Float(2)/Float(moleLevel.rawValue))), target: self, selector: (#selector(ViewController.runGame)), userInfo: nil, repeats: true)
    }
    
    func runGame(){
        updateTimer()
        if !gameFinished {
        let cell = getEmptyMoleCell()
        cell.setMoleUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3/moleLevel.rawValue)  + Double(addShakeTime), execute: { [weak self] in
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
        if activeMoles.count > 0 {
            for index in activeMoles{
                addToMoleCells(cellIndex: index)
            }
            let cellIndex = activeMoles.removeLast()
            addToMoleCells(cellIndex: cellIndex)
        }
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
        self.becomeFirstResponder()
        //self.collectionView!.register(MoleCollectionViewCell.self , forCellWithReuseIdentifier: "MoleCollectionViewCell")
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        gameDataView.layer.cornerRadius = 5
        gameDataView.layer.borderWidth = 3
        gameDataView.layer.borderColor = UIColor.brown.cgColor
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        numOfRows = Int((screenHeight-100)/106)
        numOfCols = Int(screenWidth / 106)
        
        
        //createCells()
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
        updateShaken()
        
    }
    func updateShaken(){
        shakenNumLabel.text = "\(numOfShakes)"
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

    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if numOfShakes <= 3 {
                addShakeTime += 3
                numOfShakes += 1
                updateShaken()
            }
        }
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
        
        let action =  UIAlertAction(title: "Okay",style: UIAlertActionStyle.default, handler: {
            action in self.performSegue(withIdentifier: "leaderSegue", sender: self)
        })
        
        updateCurrentUserScore()
        
        alertMsg.addAction(action)
        present(alertMsg, animated: true, completion: nil)
        
    }
    
    func updateCurrentUserScore(){
        let currentUser = DBController.getUsetDetails()
        
        let predicate = NSPredicate(format: "firstName == %@ && lastName == %@", currentUser.firstName!, currentUser.lastName!)
        let fetchRequest : NSFetchRequest<WhckAFrogGameUser> = WhckAFrogGameUser.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let user = try DBController.getContext().fetch(fetchRequest) as [WhckAFrogGameUser]
            user.first?.score = Int32(currentScoreValue)
            user.first?.misses = Int32(numOfMisses)

        } catch {
            print("Error in updtae user current score, \(error)")
        }
        
        DBController.saveContext()
            
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
        
        cells.append([indexPath.row, indexPath.section])
        return cell
    }
    
}


