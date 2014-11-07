//
//  MakePackageViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class MakePackageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var alertViewShown: Bool = false
    var supportedLanagages: [Dictionary<String,String>] = []
    var targetLanaguage: String?

    @IBOutlet var buttonDo: UIBarButtonItem!
    @IBOutlet var textFieldBundleID: UITextField!
    @IBOutlet var textViewCorpus: UITextView!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func onDoTapped(sender: UIBarButtonItem) {
        // Return if info is not there
        if textViewCorpus.text == "" || textFieldBundleID.text == "" { return }
        
        // Tokenize the corpus
        var tokens: [String] = Parser.sortedUniqueTokensFor(self.textViewCorpus.text)
        tokens = tokens.filter{$0 != ""}
        
        // Translate each token and make words
        var words: [Word] = []
//        for token in tokens {
//            GoogleTranslate.sharedInstance.translate(token, completionHandler: { (translation, err) -> () in
//                if err == ERR_GOOGLE_API_NETWORD_CONNECTION {
//                    self.showErrorAlertWithMesssage("ERR_GOOGLE_API_NETWORD_CONNECTION!")
//                    return
//                }
//                
//                var word = Word(name: token, meaning: translation!, sentences: [])
//                words.append(word)
//                
//                if words.count == tokens.count {
//                    self.onTranslationFinished(words)
//                }
//            })
//        }
    }
    
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
    
    override func viewDidLoad() {
        textViewCorpus.text = " Nach der Schlappe der Demokraten von Präsident Obama bei den US-Kongresswahlen können die Republikaner nun die politische Agenda maßgeblich beeinflussen. Doch zwei Jahre Blockade können sie sich nicht leisten"
        
        GoogleTranslate.sharedInstance.supportedLanguages { (languages: [Dictionary<String, String>]?, err) -> () in
            if err == nil && languages != nil {
                self.supportedLanagages = languages!
                self.tableView.reloadData()
            } else {
                self.showErrorAlertWithMesssage("ERR_GOOGLE_API_NETWORD_CONNECTION!")
            }
        }
        
        GoogleTranslate.sharedInstance.detectLanaguage(self.textViewCorpus.text, completionHandler: { (detectedLanguage, err) -> () in
            print(detectedLanguage)
        })
    }
    
    func onTranslationFinished(words: [Word]) {
        LearningPackPersController.sharedInstance.addNewPackage(textFieldBundleID.text, words: words)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navigationController() -> UINavigationController {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.rootNavigationController!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportedLanagages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell_supported_languages") as UITableViewCell?
        
        cell?.detailTextLabel!.text = supportedLanagages[indexPath.row]["language"]
        cell?.textLabel.text = supportedLanagages[indexPath.row]["name"]
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        targetLanaguage = cell.detailTextLabel!.text
    }
}
