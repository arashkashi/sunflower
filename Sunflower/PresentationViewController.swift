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
    
    func sentenceViewController(word: Word, sentenceIndex: Int) -> SampleSentenceViewController {
        var sentenceVC = SampleSentenceViewController(nibName: "SampleSentenceViewController", bundle: NSBundle.mainBundle())
        sentenceVC.sentence = word.sentences[sentenceIndex]
        
        return sentenceVC
    }
    
    // MARK: DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return self.sentenceViewController(self.word!, sentenceIndex: 0)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return self.sentenceViewController(self.word!, sentenceIndex: 0)
    }
}
