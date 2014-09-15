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
    
    func testSortWords() {
        var word1 = Word(name: "word future", meaning: "Meaning1")
        var word2 = Word(name: "word past", meaning: "Meaning2")
        var word3 = Word(name: "word nil 1", meaning: "Meaning3")
        var word4 = Word(name: "word nil 2", meaning: "Meaning4")
        var word5 = Word(name: "word nil 3", meaning: "Meaning4")
        
        word1.learningDueDate = NSDate().dateByAddingTimeInterval(1000)
        word2.learningDueDate = NSDate().dateByAddingTimeInterval(-1000)
        
        var list: [Word] = [word5, word1, word4, word2, word3]
        
        sort(&list, {$0 < $1})
        
        XCTAssert(list[0] == word2, "the first word is in past, \(list[0])")
        XCTAssert(list[1] == word5, "the second word has nil due date, \(list[1])")
        XCTAssert(list[2] == word4, "the second word has nil due date, \(list[2])")
        XCTAssert(list[3] == word3, "the second word has nil due date, \(list[3])")
        XCTAssert(list[4] == word1, " the last word has due date in future, , \(list[4])")
    }
    
    func testWordEqualComp() {
        var word1 = Word(name: "word future", meaning: "Meaning1")
        var word2 = Word(name: "word past", meaning: "Meaning2")
        var word3 = Word(name: "word past", meaning: "Meaning2")
        
        XCTAssert(!(word1 == word2), "when not equal")
        XCTAssert(word2 == word3, "when equal")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
