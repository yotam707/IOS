//
//  MainScoreViewController.swift
//  WhackAFrog
//
//  Created by Yotam Bloom on 6/24/17.
//  Copyright © 2017 Yotam Bloom. All rights reserved.
//

import UIKit

class MainScoreViewController: UIViewController {
    
     @IBOutlet weak var segmentedController: UISegmentedControl!
     @IBOutlet weak var finishBtn: UIButton!
    
    lazy var  leaderBoardViewController : LeaderBoardViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(withIdentifier: "LeaderBoardViewController") as! LeaderBoardViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    lazy var  mapLeadersViewController : MapLeadersViewController = {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyBoard.instantiateViewController(withIdentifier: "MapLeadersViewController") as! MapLeadersViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func setupView(){
        setupSegementedController()
        updateView()
    }
    
    func updateView(){
        leaderBoardViewController.view.isHidden = !(segmentedController.selectedSegmentIndex == 0)
        mapLeadersViewController.view.isHidden = (segmentedController.selectedSegmentIndex == 0)
    }
    
    func setupSegementedController(){
        segmentedController.removeAllSegments()
        segmentedController.insertSegment(withTitle: "List" , at: 0, animated: false)
        segmentedController.insertSegment(withTitle: "Map" , at: 1, animated: false)
        segmentedController.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedController.selectedSegmentIndex = 0
    }
    
    
    func selectionDidChange(sender: UISegmentedControl){
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "backToMain"){
            
        }
    }
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
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
