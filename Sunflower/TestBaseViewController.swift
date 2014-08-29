//
//  TestBaseViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 28/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class TestBaseViewController : UIViewController {
    var word : Word?
    var testType: TestType?
    
    var completionHandler: ((TestType, TestResult, Word) -> ())?
    
    @IBOutlet var wordLabel: UILabel!
    
    override func viewDidLoad() {
        self.wordLabel!.text = self.word!.name
    }
    
    @IBAction func onTestFail(sender: AnyObject) {
        self.completionHandler?(self.testType!, TestResult.Fail, self.word!)

    }
    
    @IBAction func onTestPass(sender: AnyObject) {
        self.completionHandler?(self.testType!, TestResult.Pass, self.word!)
    }
}
