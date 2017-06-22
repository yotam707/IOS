//
//  LeaderBoardViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/3/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit
import CoreData

class LeaderBoardViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var leaderUITableView: UITableView!
    var bestRank : [String] = ["1", "2", "3", "4", "5"]
    var bestScore: [String] = ["-----", "-----", "-----", "-----", "-----"]
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderUITableView.delegate = self
        leaderUITableView.dataSource = self
         fetchEntities()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  leaderUITableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! LeaderCell
        
        cell.column1.text = self.bestRank[indexPath.row]
        cell.column2.text = self.bestScore[indexPath.row]
        cell.column3.text = self.bestScore[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    func fetchEntities(){
        //let currentUser = DBController.getUsetDetails()
        
        //let predicate = NSPredicate(format: "firstName == %@ && lastName == %@", currentUser.firstName!, currentUser.lastName!)
        let sortDesc = NSSortDescriptor(key: "score", ascending: true)
        let fetchReq: NSFetchRequest<WhckAFrogGameUser> = WhckAFrogGameUser.fetchRequest()
        let sortDescs = [sortDesc]
        fetchReq.sortDescriptors = sortDescs
        
        //let users = try DBController.getContext().fetch(fetchReq)
        //fetchRequest.predicate = predicate
        
        do {
            let users = try DBController.getContext().fetch(fetchReq)
            for res in users as [WhckAFrogGameUser]{
                print("\(res.firstName!)  \(res.lastName!)  \(res.latitude)  \(res.longitude) \(res.score)")
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
