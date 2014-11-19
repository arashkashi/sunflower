//
//  MakePackageViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class AddOneViewController: UIViewController, UITextViewDelegate {
    
    var alertViewShown: Bool = false
    var supportedLanagages: [Dictionary<String,String>] = []
    var targetLanaguage: String?
    @IBOutlet var textViewCorpus: UITextView!


//    @IBAction func onNextTapped(sender: UIBarButtonItem) {
//        // Return if info is not there
//        if textFieldBundleID.text == "" {
//            self.showAllertForMissingInfo("unique bundle id on top white textbox is missing")
//            return
//        }
//        
//        if textViewCorpus.text == "" {
//            self.showAllertForMissingInfo("some text to learn is missing in the middle box")
//            return
//        }
//        
//        if targetLanaguage == nil {
//            self.showAllertForMissingInfo("select target language from the lower table")
//            return
//        }
//        
//        GoogleTranslate.sharedInstance.detectLanaguage(self.textViewCorpus.text, completionHandler: { (detectedLanguage: String?, err: String?) -> () in
//
//            if detectedLanguage != nil && err == nil {
//                
//                var tokens: [String] = Parser.sortedUniqueTokensFor(self.textViewCorpus.text)
//                
//                ParserHelper.translatedWordsFromStringTokens(tokens, sourceLanaguage: detectedLanguage!, targetLanguage: self.targetLanaguage!, completionHandler: { (words, err, cost) -> () in
//                    
//                    if err == nil && words?.count > 0 {
//                        CreditManager.sharedInstance.spend(cost)
//                        self.onTranslationFinished(words!, corpus: self.textViewCorpus.text)
//                    } else {
//                        self.showErrorAlertWithMesssage("Translating to tokens failed")
//                    }
//                })
//                
//            } else {
//                self.showErrorAlertWithMesssage("Could not detect the source language")
//            }
//        })
//    }
    
    @IBAction func onNextTapped(sender: AnyObject) {
        if textIsCorrect() {
            self.performSegueWithIdentifier("fromaddonetoaddtwo", sender: nil)
        } else {
            showErrorAlertWithMesssage("Some thing is not correct")
        }
    }
    
    func textIsCorrect() -> Bool {
        return true
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
    
    func showAllertForMissingInfo(message: String) {
        var alertController =  UIAlertController(title: "Missing Info", message: message, preferredStyle: .ActionSheet )
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            
        }
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
    override func viewDidLoad() {
        textViewCorpus.text = " Nach der Schlappe der Demokraten von Präsident Obama bei den US-Kongresswahlen können die Republikaner nun die politische Agenda maßgeblich beeinflussen. Doch zwei Jahre Blockade können sie sich nicht leisten"
    }
    
    func navigationController() -> UINavigationController {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.rootNavigationController!
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
