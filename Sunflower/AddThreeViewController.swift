//
//  AddThreeViewController.swift
//  Sunflower
//
//  Created by Arash K. on 18/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class AddThreeViewController: UIViewController, UITableViewDataSource {
    var tokens: [String]!
    var corpus: String!
    var sourceLanguage: String!
    var supportedLanagages: [Dictionary<String, String>]!
    var selectedLanguage: String?
    
    var alertViewShown: Bool = false
    var waitingVC: WaitingViewController?
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: Actions
    @IBAction func onMakeTapped(sender: UIBarButtonItem) {
        
    }

    // MARK: UIViewController override
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSupportedLanguages()

    }

    func updateSupportedLanguages() {
        showWaitingOverlay()
        GoogleTranslate.sharedInstance.supportedLanguages { (languages: [Dictionary<String, String>]?, err) -> () in
            self.hideWaitingOverlay()
            if err == nil && languages != nil {
                self.supportedLanagages = languages!
                self.tableView.reloadData()
            } else {
                // TODO: Handle error more elegantly
                self.showErrorAlertWithMesssage("Could not load the supported languages!")
            }
        }
    }
    
    // MARK: View manipulation
    func showErrorAlertWithMesssage(message: String) {
        if alertViewShown { return }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK!", style: .Cancel) { (action) in
            self.alertViewShown = false
        }
        
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
            self.alertViewShown = true
        }
    }
    
    func showAllertForMissingInfo(message: String) {
        var alertController =  UIAlertController(title: "Missing Info", message: message, preferredStyle: .ActionSheet )
        
        var retryAction = UIAlertAction(title: "re-try", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        var cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        alertController.addAction(retryAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
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
    
    func gobackToMainView() {
        performSegueWithIdentifier("fromthreetomain", sender: nil)
    }
    
    // MARK: Table view data source / delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if supportedLanagages != nil { return supportedLanagages.count } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell_supported_languages") as UITableViewCell?
        
        cell?.detailTextLabel!.text = supportedLanagages[indexPath.row]["language"]
        cell?.textLabel.text = supportedLanagages[indexPath.row]["name"]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        selectedLanguage = cell.detailTextLabel!.text
    }
}
