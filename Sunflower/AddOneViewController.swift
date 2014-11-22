//
//  MakePackageViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class AddOneViewController: UIViewController, UITextViewDelegate {
    
    var tokens: [String]?
    var sourceLanguage: String?
    var alertViewShown: Bool = false
    var waitingVC: WaitingViewController?
    @IBOutlet var textViewCorpus: UITextView!
    @IBOutlet var labelTotalTokens: UILabel!
    @IBOutlet var labelTotalCost: UILabel!


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
    
    // MARK: UIViewController Override
    override func viewDidLoad() {
        textViewCorpus.text = " Nach der Schlappe der Demokraten von Präsident Obama bei den US-Kongresswahlen können die Republikaner nun die politische Agenda maßgeblich beeinflussen. Doch zwei Jahre Blockade können sie sich nicht leisten"
        if textViewCorpus.text != "" {
            self.updateTokens()
            self.updateLabels()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromaddonetoaddtwo" {
            var vc = segue.destinationViewController as AddTwoViewController
            vc.tokens = self.tokens!
            vc.corpus = self.textViewCorpus.text
            vc.sourceLanguage = self.sourceLanguage!
        }
    }

    // MARK: IB Action
    @IBAction func onNextTapped(sender: AnyObject) {
        // Generate the raw tokens
        updateTokens()
        
        // Check if the tokens and text are valid, if not valid, return
        if textLengthCorrect() && tokens != nil {
            if self.tokens!.count < 5 {
                self.showErrorAlertWithMesssage("Text could not split into enought number of tokens, currently have \(self.tokens!.count) tokens")
                return
            }
        } else {
            self.showErrorAlertWithMesssage("Enter text between 20 to 1000 characters. Current text has \(self.textViewCorpus.text.length()) characters")
            return
        }
        
        // Show waiting overlay
        showWaitingOverlay()
        
        // Detect the source language, if error inform user and stay
        GoogleTranslate.sharedInstance.detectLanaguage(self.textViewCorpus.text, completionHandler: { (detectedLanguage: String?, err: String?) -> () in
            if err != nil || detectedLanguage == nil { self.showErrorAlertWithMesssage("Could not detect the source language"); return }
            
            self.sourceLanguage = detectedLanguage!
            
            self.performSegueWithIdentifier("fromaddonetoaddtwo", sender: nil)
        })
        
        hideWaitingOverlay()
    }
    
    // MARK: Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateLabels()
        return true
    }
    
    // MARK: Logic
    func textLengthCorrect() -> Bool {
        var text = self.textViewCorpus.text
        if let enteredText = text {
            var length =  enteredText.length()
            println(length)
            if length < 1000 && length > 20 {
                return true
            }
        }
        return false
    }
    
    func updateTokens() {
        self.tokens = Parser.sortedUniqueTokensFor(self.textViewCorpus.text)
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
    
    func updateTotalToken() {
        if let extractedTokens = self.tokens {
            self.labelTotalTokens.text = "Tokens: \(extractedTokens.count)"
        } else {
           self.labelTotalTokens.text = "Tokens: 0"
        }
    }
    
    func updateCost() {
        updateTokens()
        if let enteredTokens = self.tokens {
            self.labelTotalCost.text = "Cost: \(GoogleTranslate.sharedInstance.costToTranslate(enteredTokens))"
        } else {
            self.labelTotalCost.text = "Cost: 0"
        }
    }
    
    func updateLabels() {
        updateCost()
        updateTotalToken()
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
    
    // MARK: Helper
    func navigationController() -> UINavigationController {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.rootNavigationController!
    }
}