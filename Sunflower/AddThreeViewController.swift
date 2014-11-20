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
    var supportedLanagages: [String]
    
    var alertViewShown: Bool = false
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onTranslationFinished(words: [Word], corpus: String?) {
//        LearningPackPersController.sharedInstance.addNewPackage(textFieldBundleID.text, words: words, corpus: corpus)
//        self.navigationController?.popViewControllerAnimated(true)
    }

//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return supportedLanagages.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("cell_supported_languages") as UITableViewCell?
//        
//        cell?.detailTextLabel!.text = supportedLanagages[indexPath.row]["language"]
//        cell?.textLabel.text = supportedLanagages[indexPath.row]["name"]
//        
//        return cell!
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var cell = tableView.cellForRowAtIndexPath(indexPath)!
//        
//        targetLanaguage = cell.detailTextLabel!.text
//    }
    // MARK: Logic
    func updateSupportedLanguages() {
        GoogleTranslate.sharedInstance.supportedLanguages { (languages: [Dictionary<String, String>]?, err) -> () in
            if err == nil && languages != nil {
                self.supportedLanagages = languages!
                self.tableView.reloadData()
            } else {
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
    
    // MARK: Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    }



}
