//
//  ResultViewController.swift
//  Sunflower
//
//  Created by Arash K. on 06/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var viewCorrectContainer: UIView!
    @IBOutlet var viewWrongContainer: UIView!
    @IBOutlet var viewTint: UIView!
    
    let animationDuration: NSTimeInterval = 0.5
    
    
    override func viewDidLoad() {
        self.hideAll(false, nil)
    }
    
    // MARK: View manipulation
    func showCorrect(isAnimated: Bool, completionHandler: (()->())?) {
        self.tintMainView(nil)
        self.slideViewUp(viewCorrectContainer, isAnimated: isAnimated, completionHandler)
    }
    
    func hideCorrect(isAnimated: Bool, completionHandler: (()->())?) {
        self.slideViewDown(viewCorrectContainer, isAnimated:isAnimated, completionHandler)
    }
    
    func showWrong(isAnimated: Bool, completionHandler: (()->())?) {
        self.tintMainView(nil)
        self.slideViewUp(viewWrongContainer, isAnimated: isAnimated, completionHandler)
    }
    
    func hideWrong(isAnimated: Bool, completionHandler: (()->())?) {
        self.slideViewDown(viewWrongContainer, isAnimated: isAnimated, completionHandler)
    }
    
    func hideAll(isAnimated: Bool, completionHandler: (()->())?) {
        self.slideViewDown(viewCorrectContainer, isAnimated: isAnimated, completionHandler)
        self.slideViewDown(viewWrongContainer, isAnimated: isAnimated, nil)
    }
    
    func tintMainView(completionHandler: (()->())?) {
        viewTint.alpha = 0.0
        viewTint.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.viewTint.alpha = 0.8
            }) { (success: Bool) -> Void in
                if completionHandler != nil {
                    completionHandler!()
                }
        }
    }
    
    // MARK: Helper (View Manipulation)
    func slideViewUp(view: UIView, isAnimated: Bool, animationEndedHandler: (()->())?) {
        if isAnimated {
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                view.center = CGPointMake(view.center.x, 230)
                }, completion: { (success: Bool) -> Void in
                    if animationEndedHandler != nil {
                        animationEndedHandler!()
                    }
            })
        } else {
            view.center = CGPointMake(view.center.x, 230)
        }
    }
    
    func slideViewDown(view: UIView, isAnimated: Bool, animationEndedHandler: (()->())?) {
        if isAnimated {
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                view.center = CGPointMake(view.center.x, 1000)
                }, completion: { (success: Bool) -> Void in
                    if animationEndedHandler != nil {
                        animationEndedHandler!()
                    }
            })
        } else {
            view.center = CGPointMake(view.center.x, 1000)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}