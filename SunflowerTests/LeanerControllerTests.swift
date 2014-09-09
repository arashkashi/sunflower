//
//  LeanerControllerTests.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest
import Foundation

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
    
    func giveMeNextWord() -> Word? {
        var result = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, dueNowWords: &self.learnerController.wordsDueNow, currentQueue: &self.learnerController.currentLearningQueue)
        return result.word
    }
    
    func firstWordDoneWithFirstTestAndResult(testResult: TestResult) -> (word: Word, testType: TestType) {
        var firstWordToLearn = self.giveMeNextWord()
        var firstTestType = Test.testSetForLearningStage(firstWordToLearn!.currentLearningStage)[0]
        self.learnerController.onWordFinishedTestType(firstWordToLearn!, testType: firstTestType, testResult: testResult)
        
        return (firstWordToLearn!, firstTestType)
    }
    
    // Pick up the first word and put it into the current queue
    func testFirstWordPickup() {
        var firstWordToLearn = self.giveMeNextWord()

        XCTAssert(firstWordToLearn!.learningDueDate == nil, "the first word due date is nil")
        XCTAssert(firstWordToLearn!.currentLearningStage == LearningStage.Cram, "learning Stage is cram")
        XCTAssert(firstWordToLearn!.name == "schwangerschaft", "learning Stage is cram")
        XCTAssert(contains(self.learnerController.currentLearningQueue, firstWordToLearn!) , "the next word should bein the current queue")
        XCTAssert(firstWordToLearn!.shouldShowWordPresentation, "the first word should show the word presentation")
    }
    
    // First word passes the first test
    func testWordFirstTestPass() {
        var result = self.firstWordDoneWithFirstTestAndResult(TestResult.Pass)
        
        XCTAssert(result.word.testsSuccessfulyDoneForCurrentStage.count == 1, "word has passed one test and knows about it")
        XCTAssert(result.word.testsSuccessfulyDoneForCurrentStage[0] == result.testType, "it should be correct test type")
    }
    
    // First word fails the first test
    func testWordFirstTestFail() {
        var result = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail)
        
        XCTAssert(result.word.testsSuccessfulyDoneForCurrentStage.count == 0, "successful matrix should be clear")
        XCTAssert(result.word.shouldShowWordPresentation, "should show the presentation layer")
        XCTAssert(result.word.currentLearningStage == LearningStage.Cram, "learning stage should be equal to cram")
    }
    
    // When the first word fails a test, the next word should be the same word but with presentation
    func testNextWordAfterFirstTestFirstWordFailed() {
        var firstFailedTestWord = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail)
        var secondWord = self.giveMeNextWord()
        
        XCTAssert(firstFailedTestWord.word == secondWord, "when a word fails a test, next word is the same with presentation")
        XCTAssert(firstFailedTestWord.word.testsSuccessfulyDoneForCurrentStage.count == 0, "successful matrix should be clear")
        XCTAssert(firstFailedTestWord.word.shouldShowWordPresentation, "should show the presentation layer")
        XCTAssert(firstFailedTestWord.word.currentLearningStage == LearningStage.Cram, "learning stage should be equal to cram")
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
