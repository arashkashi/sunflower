//
//  PresentationViewController.swift
//  Sunflower
//
//  Created by Arash K. on 28/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class PresentationViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate  {
    
    var word : Word?
    
    @IBOutlet var pageControl: UIPageControl!
    var pageViewController: UIPageViewController!
    
    var completionHandler: (() -> ())?

    func onGotItTapped() {
        self.completionHandler?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        self.pageViewController.dataSource = self
        self.pageViewController.view.frame = self.view.bounds
        
        
        var vcs = [self.wordViewcontroller(word!)]//, self.sentenceViewController(word!, sentenceIndex: 0)!, self.sentenceViewController(word!, sentenceIndex: 1)!, self.sentenceViewController(word!, sentenceIndex: 2)!]
        
        
        self.pageViewController.setViewControllers(vcs, direction: UIPageViewControllerNavigationDirection.Forward, animated: false) { (success: Bool) -> Void in
            self.pageControl.numberOfPages = 1 + self.word!.sentences.count
        }
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.bringSubviewToFront(self.pageControl)
   }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true;
    }
    
    func wordViewcontroller(word: Word) -> WordPresentationViewController {
        var wordVC =  WordPresentationViewController(nibName: "WordPresentationViewController", bundle: NSBundle.mainBundle())
        wordVC.word = word
        
        return wordVC
    }
    
    func sentenceViewController(word: Word, sentenceIndex: Int) -> SampleSentenceViewController? {
        if sentenceIndex >=  word.sentences.count { return nil }
        
        var sentenceVC = SampleSentenceViewController(nibName: "SampleSentenceViewController", bundle: NSBundle.mainBundle())
        sentenceVC.word = word
        sentenceVC.index = sentenceIndex
        
        return sentenceVC
    }
    
    
    // MARK: DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var result: UIViewController!
        var index: Int
        
        if viewController.isMemberOfClass(WordPresentationViewController) {
            result = self.sentenceViewController(self.word!, sentenceIndex: 0)
            index = 0
        } else {
            var vc = viewController as SampleSentenceViewController
            index = vc.index! + 1
            result = self.sentenceViewController(vc.word!, sentenceIndex: index)
        }
        
        self.pageControl.currentPage = index
        return result
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var result: UIViewController!
        var index: Int
        
        if viewController.isMemberOfClass(WordPresentationViewController) {
            self.pageControl.currentPage = 0
            return nil
        } else {
            var vc = viewController as SampleSentenceViewController
            index = vc.index! - 1
            
            if index < 0 {
                result =  self.wordViewcontroller(self.word!) }
            else {
                result =  self.sentenceViewController(vc.word!, sentenceIndex: index)
            }
        }
        
        if index < 0 { index = 0 }
        self.pageControl.currentPage = index
        return result
    }
    
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        return UIPageViewControllerSpineLocation.Max
    }
    
    
}
