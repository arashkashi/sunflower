//
//  MakePackageViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class MakePackageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    var alertViewShown: Bool = false
    var supportedLanagages: [Dictionary<String,String>] = []
    var targetLanaguage: String?

    @IBOutlet var buttonDo: UIBarButtonItem!
    @IBOutlet var textFieldBundleID: UITextField!
    @IBOutlet var textViewCorpus: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonDoneEditing: UIButton!
    @IBOutlet var buttonCredit: UIButton!
    
    @IBAction func onDoneEditingTapped(sender: UIButton) {
        textViewCorpus.resignFirstResponder()
        sender.hidden = true
    }
    @IBAction func onDoTapped(sender: UIBarButtonItem) {
        // Return if info is not there
        if textFieldBundleID.text == "" {
            self.showAllertForMissingInfo("unique bundle id on top white textbox is missing", view: textFieldBundleID)
            return
        }
        
        if textViewCorpus.text == "" {
            self.showAllertForMissingInfo("some text to learn is missing in the middle box", view: textFieldBundleID)
            return
        }
        
        if targetLanaguage == nil {
            self.showAllertForMissingInfo("select target language from the lower table", view: textFieldBundleID)
            return
        }
        
        GoogleTranslate.sharedInstance.detectLanaguage(self.textViewCorpus.text, completionHandler: { (detectedLanguage: String?, err: String?) -> () in
            if detectedLanguage != nil && err == nil {
                // Tokenize the corpus
                var tokens: [String] = Parser.sortedUniqueTokensFor(self.textViewCorpus.text)
                
                
                // Translate each token and make words
                var words: [Word] = []
                var countBadTranslations: Int = 0
                
                for token in tokens {
                    GoogleTranslate.sharedInstance.translate(token, targetLanguage: self.targetLanaguage!, sourceLanaguage: detectedLanguage!, completionHandler: { (translation, err) -> () in
                        if err == ERR_GOOGLE_API_NETWORD_CONNECTION {
                            self.showErrorAlertWithMesssage("ERR_GOOGLE_API_NETWORD_CONNECTION!")
                            return
                        }
                        
                        if translation != nil && translation != "" {
                            var word = Word(name: token, meaning: translation!, sentences: [])
                            words.append(word)
                        } else {
                            countBadTranslations++
                        }

                        if words.count == tokens.count - countBadTranslations {
                            self.onTranslationFinished(words)
                        }
                    })
                }
            }
        })
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
    
    func showAllertForMissingInfo(message: String, view: UIView) {
        var alertController =  UIAlertController(title: "Missing Info", message: message, preferredStyle: .ActionSheet )
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
    override func viewDidLoad() {
        self.buttonCredit.setTitle(String(CreditManager.sharedInstance.balance), forState: UIControlState.Normal)
        textViewCorpus.text = " Nach der Schlappe der Demokraten von Präsident Obama bei den US-Kongresswahlen können die Republikaner nun die politische Agenda maßgeblich beeinflussen. Doch zwei Jahre Blockade können sie sich nicht leisten"
        
        GoogleTranslate.sharedInstance.supportedLanguages { (languages: [Dictionary<String, String>]?, err) -> () in
            if err == nil && languages != nil {
                self.supportedLanagages = languages!
                self.tableView.reloadData()
            } else {
                self.showErrorAlertWithMesssage("ERR_GOOGLE_API_NETWORD_CONNECTION!")
            }
        }
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

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        buttonDoneEditing.hidden = false
    }

}
