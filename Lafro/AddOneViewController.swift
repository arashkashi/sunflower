//
//  MakePackageViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

let MINIMUM_ALLOWED_TOKENS = 6

class AddOneViewController: UIViewController, UITextViewDelegate {
    
    var tokens: [String]?
    var sourceLanguage: String?
    var alertViewShown: Bool = false
    var waitingVC: WaitingViewController?
    @IBOutlet var textViewCorpus: UITextView!
    @IBOutlet var labelTotalTokens: UILabel!
    @IBOutlet var labelTotalCost: UILabel!
    @IBOutlet var barButtonNext: UIBarButtonItem!
    @IBOutlet weak var buttonClear: UIButton!
    
    // MARK: Layout Contraints Properties
    @IBOutlet weak var constraintTextviewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTextviewButton: NSLayoutConstraint!
    
    // MARK: Inits
    func initTextViewCorpus() {
        textViewCorpus.contentInset = UIEdgeInsetsMake(0.0, 1.0, 0.0, 0.0)
        textViewCorpus.text = " Nach der Schlappe der Demokraten von Präsident Obama"
    }
    
    // MARK: UIViewController Override
    override func viewDidLoad() {
        initTextViewCorpus()
        
        updateTokens()
        updateLabels()
        
        registerNotification()
    }
    
    func OnKeyboardShow(note: NSNotification) {
        var keyboardInfo = note.userInfo
        var keyboardFrameBegin: AnyObject? = keyboardInfo![UIKeyboardFrameBeginUserInfoKey]
        var keyboardRects = keyboardFrameBegin?.CGRectValue()
        
        // NOTE: You always change the constant in constraints and then call the layoutIfNeeded in the animation block
        self.constraintTextviewButton.constant = keyboardRects!.height + 10
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromaddonetoaddtwo" {
            var vc = segue.destinationViewController as AddTwoViewController
            vc.tokens = self.tokens!
            vc.corpus = self.textViewCorpus.text
            vc.sourceLanguage = self.sourceLanguage!
            hideWaitingOverlay()
        }
    }
    
    @IBAction func unwindToAddOne(segue: UIStoryboardSegue) {
    }

    // MARK: IB Action
    @IBAction func onNextTapped(sender: AnyObject) {
        // Show waiting overlay
        showWaitingOverlay()
        
        // Generate the raw tokens
        updateTokens()
        
        // Check if the tokens and text are valid, if not valid, return
        if textLengthCorrect() && tokens != nil {
            if self.tokens!.count < MINIMUM_ALLOWED_TOKENS {
                self.showErrorAlertWithMesssage("Text could not split into enought number of tokens, currently have \(self.tokens!.count) tokens")
                hideWaitingOverlay()
                return
            }
        } else {
            self.showErrorAlertWithMesssage("Enter text between 20 to 1000 characters. Current text has \(self.textViewCorpus.text.length()) characters")
            hideWaitingOverlay()
            return
        }
        
        // Detect the source language, if error inform user and stay
        GoogleTranslate.sharedInstance.detectLanaguage(self.textViewCorpus.text, completionHandler: { (detectedLanguage: String?, err: String?) -> () in
            if err != nil || detectedLanguage == nil {
                self.showErrorAlertWithMesssage("Could not detect the source language")
                self.hideWaitingOverlay()
                return }
            
            self.sourceLanguage = detectedLanguage!
            
            self.performSegueWithIdentifier("fromaddonetoaddtwo", sender: nil)
        })
    }
    
    @IBAction func onClearTapped(sender: UIButton) {
        textViewCorpus.text = ""
    }
    
    // MARK: Delegates
    func textViewDidChange(textView: UITextView) {
        updateLabels()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }
    
    // MARK: Logic
    func textLengthCorrect() -> Bool {
        var text = self.textViewCorpus.text
        if let enteredText = text {
            var length =  enteredText.length()
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
            self.labelTotalTokens.text = "Words: \(extractedTokens.count)"
        } else {
           self.labelTotalTokens.text = "Words: 0"
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
        self.waitingVC!.view.removeFromSuperview()
        self.waitingVC!.view.frame = self.view.bounds
        
        self.navigationItem.rightBarButtonItem = nil
        self.view.addSubview(self.waitingVC!.view)
    }
    
    func hideWaitingOverlay() {
        self.waitingVC!.view.removeFromSuperview()
        self.navigationItem.rightBarButtonItem = barButtonNext
    }
    
    // MARK: Helper
    func navigationController() -> UINavigationController {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.rootNavigationController!
    }
    
    func onNetworkReachabilityChange(notification: NSNotification) {
        var status = notification.userInfo![NOTIF_USER_INFO_REACHBILITYCHANGE]! as String
        
        if status == NOTIF_REACHABILITY_CHANGE_NO_CONNECTION
        {
            self.performSegueWithIdentifier("fromaddonetomain", sender: nil)
        }
        else if status == NOTIF_REACHABILITY_CHANGE_WIFI || status == NOTIF_REACHABILITY_CHANGE_WWLAN
        {}
    }
    
    func registerNotification() {
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIF_REACHABILITY_CHANGE, object: nil, queue: nil) { (note: NSNotification!) -> Void in
            self.onNetworkReachabilityChange(note)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { (note: NSNotification!) -> Void in
            self.OnKeyboardShow(note)
        }
    }
    
    // MARK: deinit
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
