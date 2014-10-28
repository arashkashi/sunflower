//
//  PresentationViewController.swift
//  Sunflower
//
//  Created by Arash K. on 28/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class PresentationViewController : UIPageViewController, UIPageViewControllerDataSource {
    
    var word : Word?
    
    var completionHandler: (() -> ())?

    func onGotItTapped() {
        self.completionHandler?()
    }
    
    override func viewDidLoad() {
        self.dataSource = self
        
        self.setViewControllers([self.wordViewcontroller(word!)], direction: .Forward, animated: false) { (success: Bool) -> Void in
            //
        }
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
        if viewController.isMemberOfClass(WordPresentationViewController) {
            return self.sentenceViewController(self.word!, sentenceIndex: 0)
        } else {
            var vc = viewController as SampleSentenceViewController
            var index = vc.index! + 1
            return self.sentenceViewController(vc.word!, sentenceIndex: index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isMemberOfClass(WordPresentationViewController) {
            return nil
        } else {
            var vc = viewController as SampleSentenceViewController
            var index = vc.index! - 1
            
            if index < 0 {
                return self.wordViewcontroller(self.word!) }
            else {
                return self.sentenceViewController(vc.word!, sentenceIndex: index)
            }
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
}
