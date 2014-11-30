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
    var learnerController: LearnerController?
    
    var waitingVC: WaitingViewController?
    
    // MARK: View manipulation
    func showWaitingOverlay() {
        if self.waitingVC == nil {
            self.waitingVC = WaitingViewController(nibName: "WaitingViewController", bundle: NSBundle.mainBundle())
        }
        self.waitingVC!.view.frame = self.view.bounds
        
        self.view.addSubview(self.waitingVC!.view)
    }
    
    func hideWaitingOverlay() {
        self.waitingVC!.view.removeFromSuperview()
    }
    
    func updateBalanceButton() {
        var balance = CreditManager.sharedInstance.localBalance
        self.navigationItem.leftBarButtonItem?.title = "\(balance)"
    }
    
    //MARK: Logic 
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
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For removing the white space from the top of the table
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.backgroundColor = UIColor.blackColor()
        
        self.labelTopCounter.text = "0"
        
        // Remove the top bar buttons for now
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        updateCounter()
        self.learnerController = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        updateBalanceButton()
    }

    // MARK: Segue
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_main_test" {
            var testViewController = segue.destinationViewController as MainTestViewController
//            var learningPackID = "\(self.tableView.indexPathForSelectedRow()!.row + 1)"
            
            var cell = sender as MainTableCellView
            var selectedID = cell.id
            testViewController.leaningPackID = selectedID!
            testViewController.learnerController = self.learnerController
            invalidateCashedLearningPack(selectedID!)
        } else if segue.identifier == "frommainviewtocorpus" {
            var corpusVC = segue.destinationViewController as CorpusViewController
            corpusVC.corpus = self.learnerController!.learningPackModel.corpus
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        return true
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        NSLog("Popping back to this view controller!")
        self.tableView.reloadData()
    }
    
    // MARK: Cell Delegate
    func onCellTapped(sender: UITableViewCell) {
        var cell = sender as MainTableCellView

        self.showWaitingOverlay()
        LearningPackController.sharedInstance.loadLearningPackWithID(cell.id, completionHandler: { (lpm: LearningPackModel?) -> () in
            if (lpm != nil) {
                self.learnerController = LearnerController(learningPack: lpm!)
                var status = self.learnerController!.nextWordToLearn().status
                if status == .NO_MORE_WORD_TODAY || status == .ALL_WORDS_MASTERED{
                    self.performSegueWithIdentifier("frommainviewtocorpus", sender: cell)
                } else {
                    self.performSegueWithIdentifier("to_main_test", sender: cell)
                }
                
                self.hideWaitingOverlay()
            } else {
                // TODO: Handle the error
            }
            
        })
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
