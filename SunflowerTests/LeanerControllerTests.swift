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
    
    var learnerController: LearnerController = LearnerController(learningPack: TestLearningPack.instance())

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Pick up the first word and put it into the current queue (ROOT)
    func testFirstWordPickup() {
        var firstWordToLearn = self.giveMeNextWord()

        XCTAssert(firstWordToLearn!.learningDueDate == nil, "the first word due date is nil")
        XCTAssert(firstWordToLearn!.currentLearningStage == LearningStage.Cram, "learning Stage is cram")
        XCTAssert(firstWordToLearn!.name == "schwangerschaft", "learning Stage is cram")
        XCTAssert(contains(self.learnerController.currentLearningQueue, firstWordToLearn!) , "the next word should bein the current queue")
        XCTAssert(firstWordToLearn!.shouldShowWordPresentation, "the first word should show the word presentation")
        XCTAssert(self.learnerController.wordsDueNow.count == 9, "the word should be removed from dueNow list ")
        XCTAssert(self.learnerController.currentLearningQueue.count == 1, "and added to the current learning queue")
    }
    
    // First word passes the first test 1 (ROOT)-(o)
    func testWordFirstTestPass() {
        var result = self.firstWordDoneWithFirstTestAndResult(TestResult.Pass, theTestTypeOrder: 0)
        
        XCTAssert(result.word.testsSuccessfulyDoneForCurrentStage.count == 1, "word has passed one test and knows about it")
        XCTAssert(result.word.testsSuccessfulyDoneForCurrentStage[0] == result.testType, "it should be correct test type")
    }
    
    // First word fails the first test 1 (o)-(ROOT)
    func testWordFirstTestFail() {
        var result = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail, theTestTypeOrder: 0)
        
        XCTAssert(result.word.testsSuccessfulyDoneForCurrentStage.count == 0, "successful matrix should be clear")
        XCTAssert(result.word.shouldShowWordPresentation, "should show the presentation layer")
        XCTAssert(result.word.currentLearningStage == LearningStage.Cram, "learning stage should be equal to cram")
    }
    
    // First word fails the first test 1 (o)-(ROOT)
    // When the first word fails a test, the next word should be the same word but with presentation
    func testNextWordAfterFirstTestForFirstWordFailed() {
        var firstFailedTestWord = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail, theTestTypeOrder: 0)
        var secondWord = self.giveMeNextWord()
        
        XCTAssert(firstFailedTestWord.word == secondWord, "when a word fails a test, next word is the same with presentation")
    }
    
    // First word finishes showing the presentation layer 2 (1-ROOT)
    func testOnFirstWordFinishedShowingPresentation() {
        var firstFailedTestWord = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail, theTestTypeOrder: 0)
        self.learnerController.onWordFinishedPresentation(firstFailedTestWord.word)
        
        XCTAssert(firstFailedTestWord.word.shouldShowWordPresentation == false, "the should show presentation flag should be reset")
    }
    
    // First word finishes showing the presentation after failing a test once layer 2 (1-ROOT)
    func testOnWordAfterFirstWordFinishedShowingPresentation() {
        var firstFailedTestWord = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail, theTestTypeOrder: 0)
        var nextWord = self.giveMeNextWord()
        self.learnerController.onWordFinishedPresentation(nextWord!)
        nextWord = self.giveMeNextWord()
        
        XCTAssert(nextWord!.learningDueDate == nil, "the first word due date is nil")
        XCTAssert(nextWord!.currentLearningStage == LearningStage.Cram, "learning Stage is cram")
        XCTAssert(nextWord!.name == "verhütung", "the second word in the test words list")
        XCTAssert(contains(self.learnerController.currentLearningQueue, nextWord!) , "the next word should bein the current queue")
        XCTAssert(nextWord!.shouldShowWordPresentation, "the first word should show the word presentation")
        XCTAssert(self.learnerController.currentLearningQueue.count == 2, "the learning queue now has two items in it")
        XCTAssert(self.learnerController.wordsDueNow.count == 8, "the words have been removed from the learning queue")
    }
    
    func testWordPassingAllTests() {
        // Pass the presentation for all the initial words
        for index in 1...self.learnerController.queueSize {
            var nextWord = self.giveMeNextWord()
            self.learnerController.onWordFinishedPresentation(nextWord!)
            XCTAssert(self.learnerController.currentLearningQueue.count == index, "new cards pile up in the current queue" )
            XCTAssert(self.learnerController.wordsDueInFuture.count == 0, "no words due in future")
            self.checkDataConsistency()
        }
        
        // Pass the first test for all the initial words
        for index in 1...Test.testSetForLearningStage(LearningStage.Cram).count {
            for _ in 1...self.learnerController.queueSize {
                var nextWord = self.giveMeNextWord()
                var nextTestType = nextWord?.nextTest()
                self.learnerController.onWordFinishedTestType(nextWord!, testType: nextTestType!, testResult: TestResult.Pass)
                XCTAssert(self.learnerController.currentLearningQueue.count == self.learnerController.queueSize, "the current queue: \(self.learnerController.currentLearningQueue.count) queue limit size \(self.learnerController.queueSize)")
                self.checkDataConsistency()
            }
        }
    }
    
    // #MARK: Helpers
    func printall(list: [Word]) {
        for item in list {
            println("\(item.name)")
        }
    }
    
    func checkDataConsistency() {
        XCTAssert(self.learnerController.words.count == self.learnerController.currentLearningQueue.count + self.learnerController.wordsDueInFuture.count + self.learnerController.wordsDueNow.count, "one of the data consistency criteria")
    }
    
    func giveMeNextWord() -> Word? {
        var result = self.learnerController.nextWordToLearn()
        return result.word
    }
    
    func firstWordDoneWithFirstTestAndResult(testResult: TestResult, theTestTypeOrder: Int) -> (word: Word, testType: TestType) {
        var firstWordToLearn = self.giveMeNextWord()
        var theTestType = Test.testSetForLearningStage(firstWordToLearn!.currentLearningStage)[theTestTypeOrder]
        self.learnerController.onWordFinishedTestType(firstWordToLearn!, testType: theTestType, testResult: testResult)
        
        return (firstWordToLearn!, theTestType)
    }

    // #MARK: Performace
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
