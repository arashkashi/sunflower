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
    
    var learnerController : LearnerController = LearnerController(words: TestWords.words())
    var testViewController: TestBaseViewController?
    var presentationViewController: PresentationViewController?
    
    @IBOutlet var testContentView: UIView!
    @IBOutlet var labelLearningStage: UILabel!
    
    func doTestTypeForWord(word: Word, testType: TestType, result: (TestType, TestResult, Word) -> ()) {
        self.testViewController = self.testSubViewController(testType, word: word, completionHandler: result)
        
        self.labelLearningStage.text = word.currentLearningStage.toString()
        
        UIView.transitionWithView(self.testContentView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            self.cleanTestContentView()
            self.testContentView.addSubview(self.testViewController!.view)
            }) { (isFinished: Bool) -> Void in
                // Finished Code
        }
    }
    
    func cleanTestContentView() {
        for item in self.testContentView.subviews {
            var subview: UIView = item as UIView
            subview.removeFromSuperview()
        }
    }
    
    func testSubViewController(testType: TestType, word: Word, completionHandler: ((TestType, TestResult, Word) -> ())) -> TestBaseViewController {
        var testViewController = self.viewControllerForTestType(testType)
        testViewController.word = word
        testViewController.testType = testType
        testViewController.completionHandler = completionHandler
        return testViewController
    }
    
    func onWordPresented(word: Word) {
        self.learnerController.onWordFinishedPresentation(word)
    }
    
    func viewControllerForTestType(testType: TestType) -> TestBaseViewController {
        switch testType {
        case TestType.Test1:
            return Test1ViewController(nibName: "Test1View", bundle: NSBundle.mainBundle())
        case TestType.Test2:
            return Test2ViewController(nibName: "Test2View", bundle: NSBundle.mainBundle())
        default:
            return Test1ViewController(nibName: "Test1View", bundle: NSBundle.mainBundle())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        learnNextWord()
    }
    
    func learnNextWord() {
        var next  = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, dueNowWords: &self.learnerController.wordsDueNow, currentQueue: &self.learnerController.currentLearningQueue)
        
        if next.word == nil {
            self.showNoMoreWordToLearn(next.word!)
        } else if next.word!.shouldShowWordPresentation {
            self.showPresentationView(next.word!)
        } else {
            self.doTestSetForWord(next.word!, lastPassedTest: nil,  completionHandler: { (testSetResult: TestSetResult) -> () in
                self.onTestSetFinishedForWord(next.word!, testSetResult: testSetResult)
            })
        }
    }
    
    func showNoMoreWordToLearn(word: Word) {

    }
    
    func showPresentationView(word: Word) {
        self.presentationViewController = PresentationViewController(nibName: "PresentationView", bundle: NSBundle.mainBundle())
        self.presentationViewController!.word = word
        self.presentationViewController!.completionHandler = {() -> () in self.onWordPresented(word)}
        self.labelLearningStage.text = word.currentLearningStage.toString()
        
        UIView.transitionWithView(self.testContentView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            for item in self.testContentView.subviews {
                var subview: UIView = item as UIView
                subview.removeFromSuperview()
            }
            self.testContentView.addSubview(self.presentationViewController!.view)
            }) { (isFinished: Bool) -> Void in
                // Finished Code
        }
    }
    
    func doTestSetForWord(word: Word, lastPassedTest: TestType?, completionHandler: ((TestSetResult) -> ())) {
        var nextTestType: TestType? = Test.nextTestFor(word.currentLearningStage, lastPassedTest:lastPassedTest)
        
        if nextTestType == nil {
            completionHandler(TestSetResult.pass)
        } else {
            self.doTestTypeForWord(word, testType: nextTestType!, result: { (doneTestType: TestType, doneTestResult: TestResult, word: Word) -> () in
                
                self.learnerController.onWordFinishedTestType(word, testType: doneTestType, testResult: doneTestResult)
                
                if doneTestResult == TestResult.Pass {
                    self.doTestSetForWord(word, lastPassedTest: doneTestType, completionHandler: completionHandler)
                } else if doneTestResult == TestResult.Fail {
                    completionHandler(TestSetResult.Fail)
                }
            })
        }
    }
    
    func onTestSetFinishedForWord(word: Word, testSetResult: TestSetResult) {
        if testSetResult == TestSetResult.pass {
//            self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        } else if testSetResult == TestSetResult.Fail {
//            self.learnerController.onWordFailedTestSetForCurrentLearningStage(word)
        } else {
            assert(false, "Test set result not right!")
        }
        
        self.learnNextWord()
    }
}
