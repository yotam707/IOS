//
//  MapLeadersViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/24/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapLeadersViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var userList: [WhckAFrogGameUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEntities()

        createMapView()
        // Do any additional setup after loading the view.
    }


    func createMapView(){
        let currentUser = DBController.getUsetDetails()
        let initialLocation = CLLocation(latitude: Double(currentUser.lati!)!, longitude: Double(currentUser.long!)!)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        if(userList.count > 0){
            for user in userList{
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
                let score = "Score: \(user.score)"
                let pin = WinnerAnootationPin(title: user.firstName! + " " + user.lastName! , subtitle: score, myCoordinate: coordinate)
                mapView.addAnnotation(pin)
                print("record added to map: ")
            }
        }
        

        
        
    }
    
//    func centerMapOnLocation(location: CLLocation) {
//        
//        
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        
//        
//        
//        
//        mapView.setRegion(coordinateRegion, animated: true)
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location.coordinate
//        annotation.title = "Big Ben"
//        annotation.subtitle = "London"
//        mapView.addAnnotation(annotation)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchEntities(){
        let sortDesc = NSSortDescriptor(key: "score", ascending: false)
        let fetchReq: NSFetchRequest<WhckAFrogGameUser> = WhckAFrogGameUser.fetchRequest()
        let sortDescs = [sortDesc]
        fetchReq.sortDescriptors = sortDescs
        fetchReq.fetchLimit = 10
        
        //let users = try DBController.getContext().fetch(fetchReq)
        //fetchRequest.predicate = predicate
        
        do {
            let users = try DBController.getContext().fetch(fetchReq)
            for res in users as [WhckAFrogGameUser]{
                print("\(res.firstName!)  \(res.lastName!)  \(res.latitude)  \(res.longitude) \(res.score)")
                userList.append(res)
            }
            
        } catch {
            print("Error in updtae user current score, \(error)")
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
