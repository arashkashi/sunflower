//
//  PresentationViewController.swift
//  Sunflower
//
//  Created by Arash K. on 28/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

protocol PresentationViewControllerDelegate: WordPresentationViewControllerDelegate, SampleSentenceViewControllerDelegate
{
    
}

class PresentationViewController : GAITrackedViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate, WordPresentationViewControllerDelegate, SampleSentenceViewControllerDelegate  {
    
    var word : Word?
    
    @IBOutlet var pageControl: UIPageControl!
    var pageViewController: UIPageViewController!
    var currentlyShownViewcontroller: UIViewController!
    var delegate: PresentationViewControllerDelegate?
    
    var completionHandler: (() -> ())?

    func onGotItTapped() {
        self.completionHandler?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.view.frame = self.view.bounds
        
        turnToViewContrller(self.wordViewcontroller(word!))
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.bringSubviewToFront(self.pageControl)
   }
    
    override func viewWillAppear(animated: Bool) {
        self.screenName = "PresentationViewController"
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true;
    }
    
    func wordViewcontroller(word: Word) -> WordPresentationViewController {
        var wordVC =  WordPresentationViewController(nibName: "WordPresentationViewController", bundle: NSBundle.mainBundle())
        wordVC.word = word
        wordVC.delegate = self
        
        return wordVC
    }
    
    func turnToViewContrller(viewController: UIViewController) {
        self.currentlyShownViewcontroller = viewController
        self.pageViewController.setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true) { (success: Bool) -> Void in
            self.pageControl.numberOfPages = 1 + self.word!.sentences.count
            if viewController.isMemberOfClass(WordPresentationViewController.self) {
                self.pageControl.currentPage = 0
            } else {
                var shownController = viewController as! SampleSentenceViewController
                self.pageControl.currentPage = shownController.index + 1
            }
        }
    }
    
    func sentenceViewController(word: Word, sentenceIndex: Int) -> SampleSentenceViewController? {
        if sentenceIndex >=  word.sentences.count { return nil }
        
        var sentenceVC = SampleSentenceViewController(nibName: "SampleSentenceViewController", bundle: NSBundle.mainBundle())
        sentenceVC.word = word
        sentenceVC.index = sentenceIndex
        sentenceVC.corpus = word.sentences[sentenceIndex].original
        sentenceVC.delegate = self
        
        return sentenceVC
    }
    
    // MARK: Delegate
    func onWordDictationMeaningEdited(word: Word) {
        self.delegate?.onWordDictationMeaningEdited(word)
        
        self.pageViewController.reloadInputViews()
        self.pageControl.numberOfPages = 1 + self.word!.sentences.count
        self.pageControl.reloadInputViews()
    }
    
    func onWordNewSentenceAdded(word: Word) {
        self.delegate?.onWordNewSentenceAdded(word)
        
        self.pageViewController.reloadInputViews()
        self.pageControl.numberOfPages = 1 + self.word!.sentences.count
        self.pageControl.reloadInputViews()
        
        turnToViewContrller(self.sentenceViewController(word, sentenceIndex: word.sentences.count - 1)!)
    }
    
    func onWordEdited(word: Word) {

    }
    
    func onSentenceEditted(index: Int, word: Word, isSentenceRemoved: Bool) {
        self.delegate?.onSentenceEditted(index, word: word, isSentenceRemoved: isSentenceRemoved)
        
        self.pageViewController.reloadInputViews()
        self.pageControl.numberOfPages = 1 + self.word!.sentences.count
        self.pageControl.reloadInputViews()
        
        if isSentenceRemoved {
            turnToViewContrller(self.wordViewcontroller(self.word!))
        }
    }
    
    // MARK: DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var result: UIViewController?
        
        if viewController.isMemberOfClass(WordPresentationViewController) {
            result = self.sentenceViewController(self.word!, sentenceIndex: 0)
        } else {
            var vc = viewController as! SampleSentenceViewController
            result = self.sentenceViewController(vc.word!, sentenceIndex: vc.index! + 1)
        }
        return result
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var result: UIViewController?
        
        if viewController.isMemberOfClass(WordPresentationViewController) {
            result = nil
        } else {
            var vc = viewController as! SampleSentenceViewController
            if vc.index! - 1 < 0 {
                result =  self.wordViewcontroller(self.word!) }
            else {
                result =  self.sentenceViewController(vc.word!, sentenceIndex: vc.index! - 1)
            }
        }
        return result
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        self.currentlyShownViewcontroller = pendingViewControllers[0] as! UIViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if !completed { return } 
        if self.currentlyShownViewcontroller.isMemberOfClass(WordPresentationViewController) {
            self.pageControl.currentPage = 0
        } else {
            self.pageControl.currentPage = (self.currentlyShownViewcontroller as! SampleSentenceViewController).index! + 1
        }
    }
}
