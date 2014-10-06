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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideAll(false)
    }
    
    // MARK: View manipulation
    func showCorrect(isAnimated: Bool) {
        self.slideViewUp(viewCorrectContainer, isAnimated: isAnimated)
    }
    
    func hideCorrect(isAnimated: Bool) {
        self.slideViewDown(viewCorrectContainer, isAnimated:isAnimated)
    }
    
    func showWrong(isAnimated: Bool) {
        self.slideViewUp(viewWrongContainer, isAnimated: isAnimated)
    }
    
    func hideWrong(isAnimated: Bool) {
        self.slideViewDown(viewWrongContainer, isAnimated: isAnimated)
    }
    
    func hideAll(isAnimated: Bool) {
        self.slideViewDown(viewCorrectContainer, isAnimated: isAnimated)
        self.slideViewDown(viewWrongContainer, isAnimated: isAnimated)
    }
    
    // MARK: Helper (View Manipulation)
    func slideViewUp(view: UIView, isAnimated: Bool) {
        if isAnimated {
            UIView.animateWithDuration(1, animations: { () -> Void in
                view.center = CGPointMake(view.center.x, 230)
            })
        } else {
            view.center = CGPointMake(view.center.x, 230)
        }
    }
    
    func slideViewDown(view: UIView, isAnimated: Bool) {
        if isAnimated {
            UIView.animateWithDuration(1, animations: { () -> Void in
                view.center = CGPointMake(view.center.x, -1000)
            })
        } else {
            view.center = CGPointMake(view.center.x, -1000)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
