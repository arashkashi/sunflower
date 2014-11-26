//
//  AddThreeViewController.swift
//  Sunflower
//
//  Created by Arash K. on 18/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class AddThreeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var tokens: [String]!
    var corpus: String!
    var sourceLanguage: String!
    var supportedLanagages: [Dictionary<String, String>]!
    var selectedLanguage: String?
    var selectedID: String?
    
    var alertViewShown: Bool = false
    var waitingVC: WaitingViewController?
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textFieldID: UITextField!
    @IBOutlet var barButtonItemMake: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func onMakeTapped(sender: UIBarButtonItem) {
        self.makePackageWithUIpdate()
    }

    // MARK: UIViewController override
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSupportedLanguages()
        hideMakeButton()
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
    func hideMakeButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func showMakeButton() {
        self.navigationItem.setRightBarButtonItem(barButtonItemMake, animated: true)
    }
    
    func showErrorAlertWithMesssage(message: String) {
        if alertViewShown { return }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK!", style: .Cancel) { (action) in
            self.alertViewShown = false
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true) {
            self.alertViewShown = true
        }
    }
    
    func showErrorAlertWhenFailed(error: NSError?) {
        if alertViewShown { return }
        let alertController = UIAlertController(title: "Error", message: error?.domain, preferredStyle: .Alert)
        let retryAction = UIAlertAction(title: "Re-try", style: .Default) { (action: UIAlertAction!) -> Void in
            self.alertViewShown = false
            self.makePackageWithUIpdate()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) -> Void in
            self.alertViewShown = false
            self.gobackToMainView()
        }
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
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
            self.alertViewShown = true
        }
    }
    
    func showWaitingOverlay() {
        if self.waitingVC == nil {
            self.waitingVC = WaitingViewController(nibName: "WaitingViewController", bundle: NSBundle.mainBundle())
        }
        self.waitingVC!.view.removeFromSuperview()
        self.waitingVC!.view.frame = self.view.bounds
        
        self.navigationItem.rightBarButtonItem = nil
        self.view.addSubview(self.waitingVC!.view)
    }
    
    func hideWaitingOverlay() {
        self.waitingVC!.view.removeFromSuperview()
        self.navigationItem.rightBarButtonItem = barButtonItemMake
    }
    
    func gobackToMainView() {
        performSegueWithIdentifier("fromthreetomain", sender: nil)
    }
    
    // MARK: Logic
    func makePackage( completionHandler: (Bool, NSError?)->() ) {
        LearningPackControllerHelper.makeLearningPackModelWithTransaction(self.selectedID!, tokens: tokens, corpus: corpus, sourceLanguage: sourceLanguage, selectedLanguage: selectedLanguage!) { (model: LearningPackModel?, error: NSError?) -> () in
            if model != nil {
                completionHandler(true, error)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    func makePackageWithUIpdate() {
        showWaitingOverlay()
        makePackage { (success: Bool, error: NSError?) -> () in
            self.hideWaitingOverlay()
            if success {
                self.gobackToMainView()
            } else {
                self.showErrorAlertWhenFailed(error)
            }
        }
    }
    
    // MARK: Events
    func onInputsUpdated() {
        if selectedID != nil && selectedLanguage != nil{
            showMakeButton()
        }
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
        onInputsUpdated()
    }
    
    // MARK: textField delegate
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text != nil {
            if textField.text!.length() > 0 {
                selectedID = textField.text!
                onInputsUpdated()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
