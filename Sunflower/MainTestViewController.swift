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
    @IBOutlet var labelLearningStage: UILabel!
    @IBOutlet var viewLoadingOverlay: UIView!
    
    //MARK: UIViewController Override
    override func viewDidAppear(animated: Bool) {
        learnNextWord()
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
        })
    }
    
    // #MARK: Learning logic
    func learnNextWord() {
        var next  = self.learnerController!.nextWordToLearn()
        
        if next.word == nil {
            self.showNoMoreWordToLearn()
        } else if next.word!.shouldShowWordPresentation {
            self.showPresentationView(next.word!)
        } else {
            if var nextTest = next.word!.nextTest()? {
                self.doTestTypeForWord(next.word!, test: nextTest, result: { (test: Test, testResult: TestResult, word: Word) -> () in
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
        self.labelLearningStage.text = word.currentLearningStage.toString()
        
        UIView.transitionWithView(self.testContentView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            self.cleanTestContentView()
            self.testContentView.addSubview(self.testViewController!.view)
            }) { (isFinished: Bool) -> Void in }
    }
    
    // #MARK: View manipulation 
    func showNoMoreWordToLearn() {
        
    }
    
    func showPresentationView(word: Word) {
        self.presentationViewController = PresentationViewController(nibName: "PresentationView", bundle: NSBundle.mainBundle())
        self.presentationViewController!.word = word
        self.presentationViewController!.completionHandler = {() -> ()
            
            in self.learnerController!.onWordFinishedPresentation(word)
            self.learnNextWord()
        }
        
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
    
    func showLoadingOverlay() {
        self.viewLoadingOverlay.hidden = false
    }
    
    func hideLoadingOverlay() {
        self.viewLoadingOverlay.hidden = true
    }
    
    //MARK: Helper
    func cleanTestContentView() {
        for item in self.testContentView.subviews {
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
