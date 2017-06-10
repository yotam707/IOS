//
//  RegistrationViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/1/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var FirstNameTextValue: UITextField!
    @IBOutlet weak var LastNameTextValue: UITextField!
    @IBOutlet weak var regButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstNameTextValue.delegate = self
        LastNameTextValue.delegate = self
       
        regButton.isEnabled = false
        FirstNameTextValue.addTarget(self, action: #selector(textIsEmpty), for: .editingChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textIsEmpty(textField:  UITextField){
        regButton.isEnabled = !((FirstNameTextValue.text?.isEmpty)! && (LastNameTextValue.text?.isEmpty)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "regSague"){
//            let sController = segue.destination as! StartViewController
            createUser()
        }
    }
    
    func createUser(){
        let entityDescription = NSEntityDescription.entity(forEntityName: "GameUser", in: DBController.getContext())
        let user = WhckAFrogGameUser(entity: entityDescription!, insertInto: DBController.getContext())
        user.firstName = FirstNameTextValue.text
        user.lastName = LastNameTextValue.text
        DBController.setUserDetails(user, keyVal: "CurrentUser")
        
        let fetchReq: NSFetchRequest<WhckAFrogGameUser> = WhckAFrogGameUser.fetchRequest()
        do{
            let users = try DBController.getContext().fetch(fetchReq)
            if users.first(where:{ $0.firstName == user.firstName && $0.lastName == user.lastName}) != nil{
                print("user already exsist")
            }else{
                DBController.saveContext()
            }
            
                
            print("number of results \(users.count)")
            
            for res in users as [WhckAFrogGameUser]{
                print("\(res.firstName!)  \(res.lastName!)")
            }
        }
        catch{
            print("Error Fetching \(error)")
        }

    }

}
