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
    
    func doTestTypeForWord(word: Word, testType: TestType, result: (TestType, TestResult) -> ()) {
        self.testViewController = self.viewControllerForTestType(testType)
        self.testViewController!.word = word
        self.testViewController!.testType = testType
        self.testViewController!.completionHandler = result
        self.labelLearningStage.text = word.currentLearningStage.toString()
        
        UIView.transitionWithView(self.testContentView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            for item in self.testContentView.subviews {
                var subview: UIView = item as UIView
                subview.removeFromSuperview()
            }
            self.testContentView.addSubview(self.testViewController!.view)
            }) { (isFinished: Bool) -> Void in
                // Finished Code
        }
    }
    
    func onWordPresented(word: Word) {
        word.shouldShowWordPresentation = false
        self.learnNextWord()
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
        var nextWord = self.learnerController.nextWordToLearn()
        
        if nextWord == nil {
            self.showNoMoreWordToLearn(nextWord!)
        } else if nextWord!.shouldShowWordPresentation {
            self.showPresentationView(nextWord!)
        } else {
            self.doTestSetForWord(nextWord!, lastPassedTest: nil,  completionHandler: { (testSetResult: TestSetResult) -> () in
                self.onTestSetFinishedForWord(nextWord!, testSetResult: testSetResult)
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
            self.doTestTypeForWord(word, testType: nextTestType!, result: { (doneTestType: TestType, doneTestResult: TestResult) -> () in
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
            self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        } else if testSetResult == TestSetResult.Fail {
            self.learnerController.onWordFailedTestSetForCurrentLearningStage(word)
        } else {
            assert(false, "Test set result not right!")
        }
        
        self.learnNextWord()
    }
}
