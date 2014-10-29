//
//  MainViewController.swift
//  Sunflower
//
//  Created by Arash K. on 29/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LearningPackPersController.sharedInstance.listOfAvialablePackIDs.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    var cellOptional: MainTableCellView! = tableView.dequeueReusableCellWithIdentifier("cell_type_one") as? MainTableCellView
        cellOptional.showLoadingContent()
        
        var packID = LearningPackPersController.sharedInstance.listOfAvialablePackIDs[indexPath.row]
        
        LearningPackPersController.sharedInstance.loadLearningPackWithID(packID, completionHandler: { (learningPackModel: LearningPackModel?) -> () in
            if let lpm = learningPackModel {
                cellOptional.updateWithLearningPackModel(lpm)
            }
        })

        return cellOptional
    }

}
