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
    
    @IBOutlet var testContentView: UIView!

    @IBAction func showTest1(sender: UIButton) {
        var test1ViewController: Test1ViewController = Test1ViewController(nibName: "Test1View", bundle: NSBundle.mainBundle())
        
        UIView.transitionWithView(self.testContentView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            for subview in self.testContentView.subviews as [UIView] {
                subview.removeFromSuperview()
            }
            self.testContentView.addSubview(test1ViewController.view)
            }) { (isFinished: Bool) -> Void in
            // Finished Code
        }
    }
    
    @IBAction func showTest2(sender: UIButton) {
        var test2ViewController: Test2ViewController = Test2ViewController(nibName: "Test2View", bundle: NSBundle.mainBundle())
        
       UIView.transitionWithView(self.testContentView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
        for subview in self.testContentView.subviews as [UIView] {
            subview.removeFromSuperview()
        }
        
        self.testContentView.addSubview(test2ViewController.view)
        }) { (isFinised: Bool) -> Void in
        // Finish Code
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        learnNextWord()
    }
    
    func learnNextWord() {
        var nextWord = self.learnerController.nextWordToLearn()
        self.doTestSetForWord(nextWord!, lastPassedTest: nil,  completionHandler: { (testSetResult: TestSetResult) -> () in
            self.onTestSetFinishedForWord(nextWord!, testSetResult: testSetResult)
        })
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
    
    func doTestTypeForWord(word: Word, testType: TestType, result: (TestType, TestResult) -> ()) {
        
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
    
    func onATestTypeFinishedForWord(word: Word, testType: TestType) {
        
    }
    
    func onTestsPassedForWord(word: Word) {
        
    }
    
    func onATestFailedForWord(word: Word, failedTestType: TestType) {
        
    }
}
