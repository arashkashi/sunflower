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

class MainTestViewController : UIViewController, TestViewControllerDelegate, PresentationViewControllerDelegate {
    
    var testViewController: TestBaseViewController?
    var presentationViewController: PresentationViewController?
    
    var learnerController : LearnerController!
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
    @IBOutlet var buttonCorpus: UIButton!
    @IBOutlet var progressView: UIProgressView!
    
    //MARK: UIViewController Override
    override func viewDidAppear(animated: Bool) {
        self.updateTimerLabel()
    }
    
    func navigationController() -> UINavigationController {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.rootNavigationController!
    }
    
    override func viewDidLoad() {
        hideAllButtons()
        labelCounter.text = ""
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onAppBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onAppResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        
        if learnerController.learningPackModel.corpus == nil {
            buttonCorpus.hidden = true
        }
        
        navigationController().navigationBarHidden = true
        learnNextWord()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "corpus" {
            var vc = segue.destinationViewController as CorpusViewController
            vc.corpus = learnerController?.learningPackModel.corpus
            vc.word = currentWord
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        backuptimerValueOnExitingView()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        navigationController().navigationBarHidden = false
    }
    
    func onAppBecomeActive() {
        labelCounter.text = "\(self.secondsSpentToday)"
        
        updateTimerLabel()
    }
    
    func onAppResignActive() {
        backuptimerValueOnExitingView()
    }
    
    func updateTimer() {
        if labelCounter.text == "" {
            labelCounter.text = "\(secondsSpentToday)"
        }
        
        var prevTime = self.labelCounter.text!.toInt()!
        labelCounter.text = "\(prevTime + 1)"
    }
    
    func backuptimerValueOnExitingView() {
        secondsSpentToday = self.labelCounter.text!.toInt()!
        labelCounter.text = ""
        timer?.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        labelCounter.text = "0"
    }
    
    // #MARK: Learning logic
    func learnNextWord() {
        var next = learnerController!.nextWordToLearn()

        hideAllButtons()
        currentWord = next.word
        
        if next.word == nil {
            showNoMoreWordToLearn()
            return
        } else {
            showNextWord(next.word!)
        }
    }
    
    func showNextWord(word: Word) {
        progressView.setProgress(word.learningProgress, animated: true)
        
        if word.shouldShowWordPresentation {
            showPresentationView(word, completionHandler: { () -> () in
                self.onWordFinishedPresentation(word)
            })
            
            progressView.hidden = true
        } else {
            if var nextTest = word.nextTest()? {
                doTestTypeForWord(word, test: nextTest, result: { (test: Test, testResult: TestResult, word: Word) -> () in
                    self.onWordFinishedTesting(word, test: test, testResult: testResult)
                })
            } else {
                learnNextWord()
            }
            
            progressView.hidden = false
        }
    }
    
    func doTestTypeForWord(word: Word, test: Test, result: (Test, TestResult, Word) -> ()) {
        
        // Generate the test view controller
        self.testViewController = testSubViewController(test, word: word, completionHandler: result)
        
        // Animate the test view controller into the view
        self.animateViewContainerWithNewView(self.testViewController!.view, viewContainer: self.testContentView, completionHandler: nil)
    }
    
    // #MARK: Delegations
    func onAsnwerSelected() {
        self.hideAllButtons()
        self.testViewController?.checkAnswer({ () -> () in
            self.learnNextWord()
        })
    }
    
    func onWordEdited(word: Word) {
        learnerController.updateLearningPackDocument()
    }
    
    func onWordAdded(word: Word) {
        learnerController.learningPackModel.addWord(word)
        learnerController.queueTheWords()
    }
    
    func onSentenceEditted(index: Int, word: Word) {
        learnerController.updateLearningPackDocument()
    }
    
    // MARK: Events
    func onWordFinishedTesting(word: Word, test: Test, testResult: TestResult) {
        self.learnerController!.onWordFinishedTestType(word, test: test, testResult: testResult)
        
        progressView.setProgress(word.learningProgress, animated: true)
    }
    
    func onWordFinishedPresentation(word: Word) {
        learnerController!.onWordFinishedPresentation(word)
        learnNextWord()
    }
    
    // #MARK: IBACtion
    @IBAction func onCheckTapped(sender: UIButton) {
        hideAllButtons()
        testViewController?.checkAnswer({ () -> () in
            self.showContinueButton()
        })
    }
    
    @IBAction func onContinueTapped(sender: UIButton) {
        learnNextWord()
    }
    
    @IBAction func onGotItTapped(sender: UIButton) {
        presentationViewController?.onGotItTapped()
    }
    
    @IBAction func onSkipTapped(sender: AnyObject) {
        var alertController =  UIAlertController(title: "You Already know \"\(self.currentWord!.name)\"?", message: "Want to skip?", preferredStyle: .ActionSheet )
        
        var skipAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            if  self.currentWord != nil{
                self.learnerController?.onWordSkipped(self.currentWord!, handler: nil)
                self.learnNextWord()
            }
        }
        
        var cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            //
        }
        
        alertController.addAction(skipAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
    @IBAction func onAddNewWordTapped(sender: AnyObject) {
        var alertController =  UIAlertController(title: "Add new word", message: "Enter new word and its meaning.", preferredStyle: .Alert )
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = "new word"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = "meaning"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = "Sample sentence"
        }
        
        var addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            var nameTextfield = alertController.textFields?[0] as UITextField
            var meaningTextField = alertController.textFields?[1] as UITextField
            var sentenceTextField = alertController.textFields?[2] as UITextField
            
            var wordString  = nameTextfield.text
            var wordMeaning = meaningTextField.text
            var sampleSentence = sentenceTextField.text
            
            var word = Word(name: wordString, meaning: wordMeaning, sentences: [Sentence(original: sampleSentence, translated: "")])

            self.onWordAdded(word)
            
            var alertControllerII = UIAlertController(title: "Congratulations", message: "New word successcully added", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive) { (action: UIAlertAction!) -> Void in

            }
            
            alertControllerII.addAction(okAction)
            
            self.presentViewController(alertControllerII, animated: true, completion: nil)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            //
        }
        
    }
    
    @IBAction func onCorpusTapped(sender: AnyObject) {
        
    }
    // #MARK: View manipulation
    func showNoMoreWordToLearn() {
        self.performSegueWithIdentifier("backtomain", sender: nil)
    }
    
    func updateTimerLabel() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        self.labelCounter.text = "\(self.secondsSpentToday)"
    }
    
    func showGotIt() {
        hideAllButtons()
        showItemWithAnimation(self.buttonGotIt)
        buttonGotIt.highlighted = false
        buttonGotIt.selected = false
    }
    
    func showSkip() {
        showItemWithAnimation(self.buttonSkip)
    }
    
    func showCheckButton() {
        hideAllButtons()
        showItemWithAnimation(self.buttonCheck)
        buttonCheck.highlighted = false
        buttonCheck.selected = false
    }
    
    func showContinueButton() {
        hideAllButtons()
        showItemWithAnimation(self.buttonContinue)
        buttonContinue.selected = false
        buttonContinue.highlighted = false
    }
    
    func hideAllButtons() {
        buttonGotIt.hidden = true
        buttonContinue.hidden = true
        buttonCheck.hidden = true
        
        buttonGotIt.highlighted = false
        buttonContinue.highlighted = false
        buttonCheck.highlighted = false
    }
    
    func showItemWithAnimation(view: UIView) {
        view.hidden = false
    }
    
    func hideItem(view: UIView) {
        view.hidden = true
    }
    
    func showPresentationView(word: Word, completionHandler: ()-> ()) {
        presentationViewController = PresentationViewController(nibName: "PresentationView", bundle: NSBundle.mainBundle())
        presentationViewController!.word = word
        presentationViewController!.completionHandler = completionHandler
        presentationViewController!.delegate = self
        
        animateViewContainerWithNewView(self.presentationViewController!.view, viewContainer: self.testContentView, completionHandler: { ()->() in
            self.showGotIt()
        })
    }
    
    func animateViewContainerWithNewView(newView: UIView, viewContainer: UIView, completionHandler: (()-> ())?) {
        UIView.transitionWithView(viewContainer, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.removeAllSubviewsFor(viewContainer)
            newView.frame = viewContainer.bounds
            viewContainer.addSubview(newView)
            }) { (isFinished: Bool) -> Void in
                if isFinished { completionHandler?()}
        }
    }
    
    func showLoadingOverlay() {
        viewLoadingOverlay.hidden = false
    }
    
    func hideLoadingOverlay() {
        viewLoadingOverlay.hidden = true
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
        assert(wordChoices.includes(word) == true, "word choices should include word")
        
//        LearnerController.printListOfWords(wordChoices)
        
        if wordChoices.count != nomberOfWordChoicesNeeded {
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
    }
}
