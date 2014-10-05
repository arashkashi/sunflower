//
//  MainTestViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import Foundation

class MainTestViewController : UIViewController {
    
    var learnerController : LearnerController?
    
    var testViewController: TestBaseViewController?
    var presentationViewController: PresentationViewController?
    
    @IBOutlet var testContentView: UIView!
    @IBOutlet var viewLoadingOverlay: UIView!
    
    //MARK: UIViewController Override
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        self.initLeanerController()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    // #MARK: Initiation
    func initLeanerController() {
        self.showLoadingOverlay()
        LearningPackPersController.sharedInstance.loadLearningPackWithID(TestLearningPackIDI, completionHandler: { (lpm: LearningPackModel) -> () in
            self.learnerController = LearnerController(learningPack: lpm)
            self.hideLoadingOverlay()
            self.learnNextWord()
        })
    }
    
    // #MARK: Learning logic
    func learnNextWord() {
        var next = self.learnerController!.nextWordToLearn()
        
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
            if var nextTest = word.nextTest()? {
                self.doTestTypeForWord(word, test: nextTest, result: { (test: Test, testResult: TestResult, word: Word) -> () in
                    self.learnerController!.onWordFinishedTestType(word, test: test, testResult: testResult)
                    self.learnNextWord()
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
    
    // #MARK: View manipulation
    func showNoMoreWordToLearn() {
        
    }
    
    func showPresentationView(word: Word, completionHandler: ()-> ()) {
        self.presentationViewController = PresentationViewController(nibName: "PresentationView", bundle: NSBundle.mainBundle())
        self.presentationViewController!.word = word
        self.presentationViewController!.completionHandler = completionHandler
        
        self.animateViewContainerWithNewView(self.presentationViewController!.view, viewContainer: self.testContentView, completionHandler: nil)
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
}
