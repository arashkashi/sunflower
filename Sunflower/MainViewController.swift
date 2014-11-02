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
    
    var cashedLearningPacks = Dictionary<String, LearningPackModel>()
    
    func updateCashedLearningPack(learningPack: LearningPackModel) {
        cashedLearningPacks[learningPack.id] = learningPack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For removing the white space from the top of the table
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.backgroundColor = UIColor.blackColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var testViewController = segue.destinationViewController as MainTestViewController
        testViewController.leaningPackID = "\(self.tableView.indexPathForSelectedRow()!.row + 1)"
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        NSLog("Popping back to this view controller!")
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LearningPackPersController.sharedInstance.listOfAvialablePackIDs.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    var cellOptional: MainTableCellView! = tableView.dequeueReusableCellWithIdentifier("cell_type_one") as? MainTableCellView
        cellOptional.showLoadingContent()
        
        var packID = LearningPackPersController.sharedInstance.listOfAvialablePackIDs[indexPath.row]
        
        if let cashedLearningPack = cashedLearningPacks[packID] {
            cellOptional.updateWithLearningPackModel(cashedLearningPack)
        } else {
            LearningPackPersController.sharedInstance.loadLearningPackWithID(packID, completionHandler: { (learningPackModel: LearningPackModel?) -> () in
                if let lpm = learningPackModel {
                    self.updateCashedLearningPack(lpm)
                    cellOptional.updateWithLearningPackModel(lpm)
                }
            })
        }

        return cellOptional
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.4
    }

}
