//
//  MainViewController.swift
//  Sunflower
//
//  Created by Arash K. on 29/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelTopCounter: UILabel!
    
    var cashedLearningPacks = Dictionary<String, LearningPackModel>()
    
    func updateCashedLearningPack(learningPack: LearningPackModel) {
        cashedLearningPacks[learningPack.id] = learningPack
        updateCounter()
    }
    
    func invalidateCashedLearningPack(id:String) {
        cashedLearningPacks.removeValueForKey(id)
    }
    
    func updateCounter() {
        var counter: Int = 0
        for (id, packModel) in self.cashedLearningPacks {
            counter += packModel.wordsDueInFuture().count
        }
        self.labelTopCounter.text = "\(counter)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For removing the white space from the top of the table
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.backgroundColor = UIColor.blackColor()
        
        self.labelTopCounter.text = "0"
    }
    
    override func viewDidAppear(animated: Bool) {
        updateCounter()
    }

    @IBAction func unwindToMain(segue: UIStoryboardSegue) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_main_test" {
            var testViewController = segue.destinationViewController as MainTestViewController
//            var learningPackID = "\(self.tableView.indexPathForSelectedRow()!.row + 1)"
            
            var cell = sender as MainTableCellView
            var selectedID = cell.labelID.text
            testViewController.leaningPackID = selectedID!
            invalidateCashedLearningPack(selectedID!)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        return false
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        NSLog("Popping back to this view controller!")
        self.tableView.reloadData()
    }
    
    // MARK: Cell Delegate
    func onCellTapped(id: String) {
        println()
    }
    
    // MARK: Table View datasource delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LearningPackController.sharedInstance.listOfAvialablePackIDs.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellOptional: MainTableCellView! = tableView.dequeueReusableCellWithIdentifier("cell_type_one") as? MainTableCellView
        cellOptional.showLoadingContent()
        
        cellOptional.delegate = self
        
        var packID = LearningPackController.sharedInstance.listOfAvialablePackIDs[indexPath.row]
        
        if let cashedLearningPack = cashedLearningPacks[packID] {
            cellOptional.updateWithLearningPackModel(cashedLearningPack)
        } else {
            LearningPackController.sharedInstance.loadLearningPackWithID(packID, completionHandler: { (learningPackModel: LearningPackModel?) -> () in
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
}
