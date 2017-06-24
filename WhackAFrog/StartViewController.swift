//
//  StartViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 4/17/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import CoreData

class StartViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var myPicker: UIPickerView!
 
    
    let pickerData = ["Beginner", "Intermediate", "Expert"]
    var selctedMoleLevel: MoleLevel = MoleLevel.Beginner
//    var user: WhckAFrogGameUser = NSEntityDescription.insertNewObject(forEntityName: "GameUser", into: DBController.getContext()) as! WhckAFrogGameUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myPicker.dataSource = self
        self.myPicker.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (row) {
        case 0:
            selctedMoleLevel = MoleLevel.Beginner

        case 1:
            selctedMoleLevel = MoleLevel.Intermediate
            
        case 2:
            selctedMoleLevel = MoleLevel.Expert
            
        default:
            selctedMoleLevel = MoleLevel.Beginner
        }
        
       return  pickerData[row]
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEnumMoleFromText(val: String) -> MoleLevel{
        var currentVal: MoleLevel
        switch (val) {
            
            case "Beginner":
                currentVal =  MoleLevel.Beginner
            
            case "Intermediate":
                currentVal =  MoleLevel.Intermediate
            
            case "Expert":
                currentVal =  MoleLevel.Expert
            
        
            default:
                return MoleLevel.Beginner
        }
        
        return currentVal

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mySague"){
            let vController = segue.destination as! ViewController
            
            let selectedValue = pickerData[myPicker.selectedRow(inComponent: 0)]
            
            vController.moleLevel = getEnumMoleFromText(val: selectedValue)
            
            
        }
    }
    

 

}
