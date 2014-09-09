//
//  WordTests.swift
//  Sunflower
//
//  Created by Arash K. on 09/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class WordTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNextTestAtCram() {
        var word = Word(name: "kann", meaning: "can")
        word.testsSuccessfulyDoneForCurrentStage = [TestType.Test1]
        
        XCTAssert(word.nextTest() == TestType.Test2, " the next test should be test 1")
    }
    
    func testNextTestAtYoung() {
        var word = Word(name: "kann", meaning: "can")
        word.currentLearningStage = LearningStage.Young
        word.testsSuccessfulyDoneForCurrentStage = [TestType.Test2]
        
        XCTAssert(word.nextTest() == TestType.Test3, " the next test should be test 3")
        
        word.testsSuccessfulyDoneForCurrentStage = [TestType.Test2, TestType.Test3]
        XCTAssert(word.nextTest() == nil, "there is no test left")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
