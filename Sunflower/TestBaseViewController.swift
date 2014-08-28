//
//  TestBaseViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 28/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

protocol TestViewControllerDelegate {
    func onFinishedTesting(word: Word, testType: TestType, testResult: TestResult)
}

class TestBaseViewController : UIViewController {
    var word : Word?
    var testType: TestType?
    
    var delegate: TestViewControllerDelegate?
}
