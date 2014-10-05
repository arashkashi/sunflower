//
//  TestBaseViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 28/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

protocol TestViewControllerDelegate {
    func onAsnwerSelected()
}

class TestBaseViewController : UIViewController {
    var word : Word?
    var test: Test?
    
    var completionHandler: ((Test, TestResult, Word) -> ())?
    var delegate: TestViewControllerDelegate?
    
    @IBOutlet var wordLabel: UILabel!
    
    override func viewDidLoad() {
        self.wordLabel!.text = self.word!.name
    }
    
    // MARK: Logic
    func checkAnswer() {
        
    }
    
    // MARK: IBAction
    @IBAction func onTestFail(sender: AnyObject) {
        self.completionHandler?(self.test!, TestResult.Fail, self.word!)

    }
    
    @IBAction func onTestPass(sender: AnyObject) {
        self.completionHandler?(self.test!, TestResult.Pass, self.word!)
    }
}
