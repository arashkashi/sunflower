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
}
