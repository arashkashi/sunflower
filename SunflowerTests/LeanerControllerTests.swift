//
//  LeanerControllerTests.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class LeanerControllerTests: XCTestCase {
    
    var learnerController: LearnerController = LearnerController(words: TestWords.words())

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNoWordLearnt() {
        // When no word has ever been learnt, just pick a random word from the set
        var nextWordToLearn = self.learnerController.nextWordToLearn()
        XCTAssert(nextWordToLearn != nil, "Next word should not be nil")
    }
    
    func testTwoWordsLearnsButNotDueForReLearnYet() {
        // When there is no word to re-learn, take a fresh new word
        var words :[Word] = self.learnerController.words!
        var learntWord1: Word = words[0]
        var learntWord2: Word = words[1]
        
        learntWord1.learningDueDate = NSDate
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
