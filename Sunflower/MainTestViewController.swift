//
//  MainTestViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import Foundation

let kTimeSpent: String = "kTimeSpent"
let kDateBackup: String = "kDateBackup"

class MainTestViewController : UIViewController, TestViewControllerDelegate {
    
    var testViewController: TestBaseViewController?
    var presentationViewController: PresentationViewController?
    
    var learnerController : LearnerController?
    var currentWord: Word?
    var leaningPackID: String!
    
    var timer: NSTimer?
    var secondsSpentToday: Int  {
        get {
            var lastBackupDate: NSDate? = NSUserDefaults.standardUserDefaults().objectForKey(kDateBackup) as? NSDate
            if lastBackupDate == nil {
                self.secondsSpentToday = 0
            } else {
                if !lastBackupDate!.isToday() {
                    self.secondsSpentToday = 0
                }
            }
            return NSUserDefaults.standardUserDefaults().integerForKey(kTimeSpent)
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: kTimeSpent)
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: kDateBackup)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    @IBOutlet var buttonGotIt: UIButton!
    @IBOutlet var testContentView: UIView!
    @IBOutlet var viewLoadingOverlay: UIView!
    @IBOutlet var buttonCheck: UIButton!
    @IBOutlet var buttonContinue: UIButton!
    @IBOutlet var labelCounter: UILabel!
    @IBOutlet var buttonSkip: UIButton!
    
    //MARK: UIViewController Override
    override func viewDidAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        self.labelCounter.text = "\(self.secondsSpentToday)"
    }
    
    override func viewDidLoad() {
        self.hideAllButtons()
        self.labelCounter.text = ""
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onAppBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onAppResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        
        self.initLeanerController(self.leaningPackID)
    }
    
    override func viewWillDisappear(animated: Bool) {
        backuptimerValueOnExitingView()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onAppBecomeActive() {
        self.labelCounter.text = "\(self.secondsSpentToday)"
    }
    
    func onAppResignActive() {
        backuptimerValueOnExitingView()
    }
    
    func updateTimer() {
        if self.labelCounter.text == "" {
            self.labelCounter.text = "\(secondsSpentToday)"
        }
        
        var prevTime = self.labelCounter.text!.toInt()!
        self.labelCounter.text = "\(prevTime + 1)"
    }
    
    func backuptimerValueOnExitingView() {
        self.secondsSpentToday = self.labelCounter.text!.toInt()!
        self.labelCounter.text = ""
        timer?.invalidate()
        
        self.presentationViewController = nil
        self.testViewController = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        self.labelCounter.text = "0"
    }
    
    // #MARK: Initiation
    func initLeanerController(id: String) {
        self.showLoadingOverlay()
        LearningPackPersController.sharedInstance.loadLearningPackWithID(id, completionHandler: { (lpm: LearningPackModel?) -> () in
            if (lpm != nil) {
                self.learnerController = LearnerController(learningPack: lpm!)
                self.hideLoadingOverlay()
                self.learnNextWord()
            } else {
                // TODO: Handle the error
            }

        })
    }
    
    // #MARK: Learning logic
    func learnNextWord() {
        var next = self.learnerController!.nextWordToLearn()
        self.hideAllButtons()
        self.currentWord = next.word
        
        next.word?.printToSTD()
        
        if next.word == nil {
            self.showNoMoreWordToLearn()
            return
        } else {
            self.showNextWord(next.word!)
        }
    }
    
    func showNextWord(word: Word) {
        if word.shouldShowWordPresentation {
            self.showPresentationView(word, completionHandler: { () -> () in
                self.learnerController!.onWordFinishedPresentation(word)
                self.learnNextWord()
            })
        } else {
            self.hideItem(self.buttonSkip)
            if var nextTest = word.nextTest()? {
                self.doTestTypeForWord(word, test: nextTest, result: { (test: Test, testResult: TestResult, word: Word) -> () in
                    self.learnerController!.onWordFinishedTestType(word, test: test, testResult: testResult)
                })
            } else {
                self.learnNextWord()
            }
        }
    }
    
    func doTestTypeForWord(word: Word, test: Test, result: (Test, TestResult, Word) -> ()) {
        self.testViewController = self.testSubViewController(test, word: word, completionHandler: result)
        
        self.animateViewContainerWithNewView(self.testViewController!.view, viewContainer: self.testContentView, completionHandler: nil)
    }
    
    // #MARK: Delegations
    func onAsnwerSelected() {
        self.showCheckButton()
    }
    
    // #MARK: IBACtion
    @IBAction func onCheckTapped(sender: UIButton) {
        self.hideAllButtons()
        self.testViewController?.checkAnswer({ () -> () in
            self.showContinueButton()
        })
    }
    
    @IBAction func onContinueTapped(sender: UIButton) {
        self.learnNextWord()
    }
    
    @IBAction func onGotItTapped(sender: UIButton) {
        self.presentationViewController?.onGotItTapped()
    }
    
    @IBAction func onSkipTapped(sender: AnyObject) {
        var alertController =  UIAlertController(title: "You Already know \"\(self.currentWord!.name)\"?", message: "Want to skip?", preferredStyle: .ActionSheet )
        
        var skipAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            if  self.currentWord != nil{
                self.learnerController?.onWordSkipped(self.currentWord!)
                self.learnNextWord()
            }
        }
        
        var cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            //
        }
        
        alertController.addAction(skipAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
    // #MARK: View manipulation
    func showNoMoreWordToLearn() {
        
    }
    
    func showGotIt() {
        self.hideAllButtons()
        self.showItemWithAnimation(self.buttonGotIt)
    }
    
    func showSkip() {
        self.showItemWithAnimation(self.buttonSkip)
    }
    
    func showCheckButton() {
        self.hideAllButtons()
        self.showItemWithAnimation(self.buttonCheck)
    }
    
    func showContinueButton() {
        self.hideAllButtons()
        self.showItemWithAnimation(self.buttonContinue)
    }
    
    func hideAllButtons() {
        self.buttonGotIt.hidden = true
        self.buttonContinue.hidden = true
        self.buttonCheck.hidden = true
    }
    
    func showItemWithAnimation(view: UIView) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            view.hidden = false
        })
    }
    
    func hideItem(view: UIView) {
        view.hidden = true
    }
    
    func showPresentationView(word: Word, completionHandler: ()-> ()) {
        self.presentationViewController = PresentationViewController(nibName: "PresentationView", bundle: NSBundle.mainBundle())
        self.presentationViewController!.word = word
        self.presentationViewController!.completionHandler = completionHandler
        
        self.animateViewContainerWithNewView(self.presentationViewController!.view, viewContainer: self.testContentView, completionHandler: nil)
        
        self.showGotIt()
        
        // Allow user to skip the word when first shown
        if word.currentLearningStage == .Cram {
            self.showSkip()
        }
    }
    
    func animateViewContainerWithNewView(newView: UIView, viewContainer: UIView, completionHandler: (()-> ())?) {
        UIView.transitionWithView(viewContainer, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.removeAllSubviewsFor(viewContainer)
            newView.frame = viewContainer.bounds
            viewContainer.addSubview(newView)
            }) { (isFinished: Bool) -> Void in
            // Handle completion here
        }
    }
    
    func showLoadingOverlay() {
        self.viewLoadingOverlay.hidden = false
    }
    
    func hideLoadingOverlay() {
        self.viewLoadingOverlay.hidden = true
    }
    
    //MARK: Helper
    func removeAllSubviewsFor(view: UIView) {
        for item in view.subviews {
            var subview: UIView = item as UIView
            subview.removeFromSuperview()
        }
    }
    
    func testSubViewController(test: Test, word: Word, completionHandler: ((Test, TestResult, Word) -> ())) -> TestBaseViewController {
        var testViewController = self.viewControllerForTestType(test)
        testViewController.word = word
        testViewController.test = test
        testViewController.completionHandler = completionHandler
        
        let nomberOfWordChoicesNeeded = 4
        var wordChoices = self.learnerController!.someRandomWords(nomberOfWordChoicesNeeded - 1, excludeList: [word])
        wordChoices = wordChoices + [word]
        wordChoices.shuffle()
        
        if wordChoices.count < nomberOfWordChoicesNeeded {
            assert(false, "it should not be it")
        }
        
        if test.type == TestType.Test1 {
            (testViewController as Test1ViewController).wordChoices = wordChoices
            (testViewController as Test1ViewController).delegate = self
        }
        
        if test.type == TestType.Test2 {
            (testViewController as Test2ViewController).wordChoices = wordChoices
            (testViewController as Test2ViewController).delegate = self
        }
        
        if test.type == TestType.Test3 {
            (testViewController as Test1ViewController).wordChoices = wordChoices
            (testViewController as Test1ViewController).delegate = self
        }
        
        return testViewController
    }
    
    func viewControllerForTestType(test: Test) -> TestBaseViewController {
        switch test.type {
        case TestType.Test1:
            return Test1ViewController(nibName: "Test1View", bundle: NSBundle.mainBundle())
        case TestType.Test2:
            return Test2ViewController(nibName: "Test2View", bundle: NSBundle.mainBundle())
        default:
            return Test1ViewController(nibName: "Test1View", bundle: NSBundle.mainBundle())
        }
    }
    
    deinit {
        println()
    }
}
