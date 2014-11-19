//
//  AddThreeViewController.swift
//  Sunflower
//
//  Created by Arash K. on 18/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class AddThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        GoogleTranslate.sharedInstance.supportedLanguages { (languages: [Dictionary<String, String>]?, err) -> () in
//            if err == nil && languages != nil {
//                self.supportedLanagages = languages!
//                self.tableView.reloadData()
//            } else {
//                self.showErrorAlertWithMesssage("ERR_GOOGLE_API_NETWORD_CONNECTION!")
//            }
//        }

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
    



}
