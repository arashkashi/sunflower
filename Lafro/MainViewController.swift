//
//  MainViewController.swift
//  Sunflower
//
//  Created by Arash K. on 29/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

enum ViewControllerState: Int32 {
    case NORMAL = 1
    case MERGE_PHASE_1 = 2
    case MERGE_PHASE_2 = 3
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelTopCounter: UILabel!
    
    var viewState: ViewControllerState = .NORMAL
    var lpm_merge_1: LearningPackModel?
    
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
    }
    
    func invalidateCashedLearningPack(id:String) {
        cashedLearningPacks.removeValueForKey(id)
    }
    
    func resetCach() {
        cashedLearningPacks.removeAll(keepCapacity: true)
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
        //        self.navigationItem.leftBarButtonItem = nil
        //        self.navigationItem.rightBarButtonItem = nil
        
        registerNotification()
    }
    
    override func viewDidAppear(animated: Bool) {
        updateCounter()
        self.learnerController = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        updateBalanceButton()
        resetCach()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        resetMergeOperation()
    }
    
    // MARK: Segue
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_main_test" {
            var testViewController = segue.destinationViewController as MainTestViewController
            //            var learningPackID = "\(self.tableView.indexPathForSelectedRow()!.row + 1)"
            
            var lpm = sender as LearningPackModel
            var selectedID = lpm.id
            testViewController.leaningPackID = selectedID
            testViewController.learnerController = self.learnerController
            invalidateCashedLearningPack(selectedID)
        } else if segue.identifier == "frommainviewtocorpus" {
            var corpusVC = segue.destinationViewController as CorpusViewController
            corpusVC.corpus = self.learnerController!.learningPackModel.corpus
        } else if segue.identifier == "from_main_to_browse" {
            var broseVC = segue.destinationViewController as BrowseViewController
            var learningPack = sender as LearningPackModel
            broseVC.learningPackModel = learningPack
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        return true
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        NSLog("Popping back to this view controller!")
        self.tableView.reloadData()
    }
    
    // MARK: Events
    func onCellTapped(lpm: LearningPackModel, indexPath: NSIndexPath) {
        if viewState == .NORMAL {
            self.learnerController = LearnerController(learningPack: lpm)
            var status = self.learnerController!.nextWordToLearn().status
            if status == .NO_MORE_WORD_TODAY || status == .ALL_WORDS_MASTERED{
                self.performSegueWithIdentifier("frommainviewtocorpus", sender: lpm)
            } else {
                self.performSegueWithIdentifier("to_main_test", sender: lpm)
            }
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.hideWaitingOverlay()
        } else if viewState == .MERGE_PHASE_1 {
            var cell = self.tableView.cellForRowAtIndexPath(indexPath) as MainTableCellView
            onMergeTapped(lpm, cell: cell)
        }
    }
    
    func onDeleteTapped(lpm: LearningPackModel, cell: MainTableCellView) {
        
        cell.hideUtilityButtonsAnimated(true)
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete? You can never undo this action.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
            LearningPackController.sharedInstance.deletePackage(lpm.id, completionHandler: { (successed: Bool) -> () in
                self.tableView.reloadData()
            })
        }
        let yesAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(yesAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    func onMergeTapped(lpm: LearningPackModel, cell: MainTableCellView) {
        if viewState == .NORMAL
        {
            viewState = ViewControllerState.MERGE_PHASE_1
            cell.showMergingContent()
            labelTopCounter.text = "Choose the second row to merge with"
            lpm_merge_1 = lpm
        }
        else if viewState == .MERGE_PHASE_1
        {
            if lpm_merge_1 == lpm {
                UIAlertHelper.showErrorWhenSamePackgeSelectedForMerging(self, id: lpm.id, cancelMerge: { (action: UIAlertAction!) -> Void in
                    self.resetMergeOperation()
                })
            } else {
                UIAlertHelper.showConfirmationForMerging(self, id_1: lpm_merge_1!.id, id_2: lpm.id, yesAction: { (yesAction: UIAlertAction!) -> Void in
                    
                    LearningPackController.sharedInstance.mergePackages(self.lpm_merge_1!, lpm2: lpm, handler: { (success: Bool) -> () in
                        self.resetMergeOperation()
                    })

                    }, noAction: { (noAction: UIAlertAction!) -> Void in
                    self.resetMergeOperation()
                })
            }
        }
    }
    
    func onRenamePackageTapped(cell: MainTableCellView) {
        var selectedLPM = cashedLearningPacks[cell.id]!
        
        let alertController = UIAlertController(title: "Rename", message: "Enter the new name!", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = selectedLPM.id
            textField.autocorrectionType = .No
        }
        let okAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
            var newID = (alertController.textFields?.first as UITextField).text
            LearningPackController.sharedInstance.renamePackage(selectedLPM.id  , newName: newID) { () -> () in
                self.tableView.reloadData()
            }
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func onBrowsePackageTapped(cell: MainTableCellView) {
        self.performSegueWithIdentifier("from_main_to_browse", sender: cashedLearningPacks[cell.id]!)
    }
    
    func onNetworkReachabilityChange(notification: NSNotification) {
        var status = notification.userInfo![NOTIF_USER_INFO_REACHBILITYCHANGE]! as String
        
        if status == NOTIF_REACHABILITY_CHANGE_NO_CONNECTION {
            onNointernetConnection()
        } else if status == NOTIF_REACHABILITY_CHANGE_WIFI || status == NOTIF_REACHABILITY_CHANGE_WWLAN {
            onInternetConnectionEstablished()
        }
    }
    
    func onNointernetConnection() {
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func onInternetConnectionEstablished() {
        self.navigationItem.leftBarButtonItem?.enabled = true
        self.navigationItem.rightBarButtonItem?.enabled = true
    }
    
    // MARK: Helper
    func learningPackForIndexPath(indexPath: NSIndexPath, completionHandler:(LearningPackModel)->()) {
        var packID = LearningPackController.sharedInstance.listOfAvialablePackIDs[indexPath.row]
        
        if let cashedLearningPack = cashedLearningPacks[packID] {
            completionHandler(cashedLearningPack)
        } else {
            LearningPackController.sharedInstance.loadLearningPackWithID(packID, completionHandler: { (learningPackModel: LearningPackModel?) -> () in
                if let lpm = learningPackModel {
                    completionHandler(lpm)
                }
            })
        }
    }
    
    func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIF_REACHABILITY_CHANGE, object: nil, queue: nil) { (note: NSNotification!) -> Void in
            self.onNetworkReachabilityChange(note)
        }
    }
    
    func resetMergeOperation() {
        self.viewState = .NORMAL
        self.lpm_merge_1 = nil
        
        self.tableView.reloadData()
    }
    
    // MARK: Table View datasource delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LearningPackController.sharedInstance.listOfAvialablePackIDs.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellOptional: MainTableCellView! = tableView.dequeueReusableCellWithIdentifier("cell_type_one") as? MainTableCellView
        cellOptional.showLoadingContent()
        cellOptional.leftUtilityButtons = leftButtons()
        cellOptional.delegate = self
        
        learningPackForIndexPath(indexPath, completionHandler: { (lpm: LearningPackModel) -> () in
            self.updateCashedLearningPack(lpm)
            
            if self.viewState == .NORMAL {
                self.updateCounter()
            }
            
            if self.lpm_merge_1 == lpm {
                cellOptional.showMergingContent()
            } else {
                cellOptional.updateWithLearningPackModel(lpm)
            }
        })
        
        return cellOptional
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.showWaitingOverlay()

        learningPackForIndexPath(indexPath, completionHandler: { (lpm: LearningPackModel) -> () in
            self.hideWaitingOverlay()
            self.onCellTapped(lpm, indexPath: indexPath)
        })
    }
    
    // MARK: SWTableCellView
    func leftButtons() -> NSMutableArray {
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.greenColor(), title: "Merge")              // Index = 0
        buttons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "Delete")               // Index = 1
        buttons.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "Browse")             // Index = 2
        buttons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "Rename")              // Index = 3
        
        return buttons
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        var lpmCell = cell as MainTableCellView
        
        if index == 1 {
            onDeleteTapped(cashedLearningPacks[lpmCell.id]!, cell: lpmCell)
            return
        } else if index == 0 {
            onMergeTapped(cashedLearningPacks[lpmCell.id]!, cell: lpmCell)
        } else if index == 2 {
            onBrowsePackageTapped(lpmCell)
        } else if index == 3 {
            onRenamePackageTapped(lpmCell)
        }
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        println()
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
        return viewState == .NORMAL
    }
    
    // MARK: deinit
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}


