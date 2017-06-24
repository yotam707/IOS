//
//  RegistrationViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/1/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class RegistrationViewController: UIViewController ,UITextFieldDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var FirstNameTextValue: UITextField!
    @IBOutlet weak var LastNameTextValue: UITextField!
    @IBOutlet weak var regButton: UIButton!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstNameTextValue.delegate = self
        LastNameTextValue.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        regButton.isEnabled = false
        FirstNameTextValue.addTarget(self, action: #selector(textIsEmpty), for: .editingChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocation() {
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if status == .denied || status == .restricted {
            //Makes sure user will be prompted again if returns to game without actually making changes
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.initLocation),
                name: .UIApplicationWillEnterForeground,
                object: nil)
            
            //Creates alert
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings, it's important!", preferredStyle: UIAlertControllerStyle.alert)
            
            //Dismiesses the game view
            alert.addAction(UIAlertAction(title: "No!", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)}))
            
            //Deep link, works partially due to iOS 10 related changes
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                //For some reason this only works if the settings app is running in the background
                let url = URL(string: UIApplicationOpenSettingsURLString)
                let app = UIApplication.shared
                app.open(url!, options: [:], completionHandler: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        initLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        print(currentLocation)
    }
    
    
    
    func textIsEmpty(textField:  UITextField){
        regButton.isEnabled = !((FirstNameTextValue.text?.isEmpty)! && (LastNameTextValue.text?.isEmpty)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "regSague"){
            createUser()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func createUser(){
        let entityDescription = NSEntityDescription.entity(forEntityName: "GameUser", in: DBController.getContext())
        let user = WhckAFrogGameUser(entity: entityDescription!, insertInto: DBController.getContext())
        user.firstName = FirstNameTextValue.text
        user.lastName = LastNameTextValue.text
        user.latitude = (locationManager.location?.coordinate.latitude)!
        user.longitude = (locationManager.location?.coordinate.longitude)!
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
                print("\(res.firstName!)  \(res.lastName!)  \(res.latitude)  \(res.longitude)")
            }
        }
        catch{
            print("Error Fetching \(error)")
        }

    }

}
