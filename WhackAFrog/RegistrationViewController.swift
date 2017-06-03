//
//  RegistrationViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/1/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit

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
            let sController = segue.destination as! StartViewController
            sController.user.firstName = FirstNameTextValue.text
            sController.user.lastName = LastNameTextValue.text
        }
    }

}
