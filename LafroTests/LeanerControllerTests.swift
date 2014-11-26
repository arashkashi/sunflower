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
    
    var learnerController: LearnerController = LearnerController(learningPack: LearningPackModel(id: "test", words: RawPackage.packWithID("test")!, corpus: nil))
    
    var hasCleanedUpCash: Bool = false

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        if !hasCleanedUpCash {
            var error: NSErrorPointer = NSErrorPointer()
             NSFileManager.defaultManager().removeItemAtURL(self.learnerController.learningPackModel.fileURL, error: error)
            if error != nil{
                println()
            }
            hasCleanedUpCash = true
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // when skip the first word we should proceed with the nest words
    func testSkipTheFirstWord() {
        var skippedWords: [Word] = []
        for _ in 1...10 {
            var word = self.giveMeNextWord()
            XCTAssert(!skippedWords.includes(word!), "skipped words should not reaccure")
            self.learnerController.onWordSkipped(word!, handler: nil)
            skippedWords.append(word!)
        }
    }
    
    // When skip a word it should be aitomatically added to the future list
    func testAddSkippedWordToFuturelist() {
        var skippedWords: [Word] = []
        for i in 1...3 {
            var word = self.giveMeNextWord()
            self.learnerController.onWordSkipped(word!, handler: { () -> () in
                XCTAssertFalse(self.learnerController.wordsDueInFuture.includes(word!), "remove from queue")
                XCTAssertFalse(self.learnerController.wordsDueNow.includes(word!), "remove from queue")
                XCTAssertFalse(self.learnerController.currentLearningQueue.includes(word!), "remove from queue")
                
                // Remove from the current model
                XCTAssertFalse(self.learnerController.learningPackModel.words.includes(word!), "remove from model")
                
                // Add to the skipped model
                LearningPackControllerSkipHelper.loadSkipLearningPackModel({ (model: LearningPackModel!) -> () in
                    XCTAssertTrue(model.words.includes(word!), "add to skip model")
                })
            })
        }
    }
    
    // Pick up the first word and put it into the current queue (ROOT)
    func testFirstWordPickup() {
        var firstWordToLearn = self.giveMeNextWord()

        XCTAssert(firstWordToLearn!.relearningDueDate == nil, "the first word due date is nil")
        XCTAssert(firstWordToLearn!.currentLearningStage == LearningStage.Cram, "learning Stage is cram")
        XCTAssert(firstWordToLearn!.name == "ich", "learning Stage is cram")
        XCTAssert(contains(self.learnerController.currentLearningQueue, firstWordToLearn!) , "the next word should bein the current queue")
        XCTAssert(firstWordToLearn!.shouldShowWordPresentation, "the first word should show the word presentation")
        self.checkDataConsistency()
        XCTAssert(self.learnerController.currentLearningQueue.count == 1, "and added to the current learning queue")
    }
    
    // First word fails the first test 1 (o)-(ROOT)
    func testWordFirstTestFail() {
        var result = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail)
        
        XCTAssert(result.word.testsSuccessfulyDoneForCurrentStage.count == 0, "successful matrix should be clear")
        XCTAssert(result.word.shouldShowWordPresentation, "should show the presentation layer")
        XCTAssert(result.word.currentLearningStage == LearningStage.Cram, "learning stage should be equal to cram")
    }
    
    // First word fails the first test 1 (o)-(ROOT)
    // When the first word fails a test, the next word should be the same word but with presentation
    func testNextWordAfterFirstTestForFirstWordFailed() {
        var firstFailedTestWord = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail)
        var secondWord = self.giveMeNextWord()
        
        XCTAssert(firstFailedTestWord.word == secondWord, "when a word fails a test, next word is the same with presentation")
    }
    
    // First word finishes showing the presentation layer 2 (1-ROOT)
    func testOnFirstWordFinishedShowingPresentation() {
        var firstFailedTestWord = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail)
        self.learnerController.onWordFinishedPresentation(firstFailedTestWord.word)
        
        XCTAssert(firstFailedTestWord.word.shouldShowWordPresentation == false, "the should show presentation flag should be reset")
    }
    
    // First word finishes showing the presentation after failing a test once layer 2 (1-ROOT)
    func testOnWordAfterFirstWordFinishedShowingPresentation() {
        var firstFailedTestWord = self.firstWordDoneWithFirstTestAndResult(TestResult.Fail)
        var nextWord = self.giveMeNextWord()
        self.learnerController.onWordFinishedPresentation(nextWord!)
        nextWord = self.giveMeNextWord()
        
        XCTAssert(nextWord!.relearningDueDate == nil, "the first word due date is nil")
        XCTAssert(nextWord!.currentLearningStage == LearningStage.Cram, "learning Stage is cram")
        XCTAssert(nextWord!.name == "sie", "the second word in the test words list")
        XCTAssert(contains(self.learnerController.currentLearningQueue, nextWord!) , "the next word should bein the current queue")
        XCTAssert(nextWord!.shouldShowWordPresentation, "the first word should show the word presentation")
        XCTAssert(self.learnerController.currentLearningQueue.count == 2, "the learning queue now has two items in it")
        self.checkDataConsistency()
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
                var nextTest = nextWord?.nextTest()
                self.learnerController.onWordFinishedTestType(nextWord!, test: nextTest!, testResult: TestResult.Pass)
                XCTAssert(self.learnerController.currentLearningQueue.count == self.learnerController.queueSize, "the current queue: \(self.learnerController.currentLearningQueue.count) queue limit size \(self.learnerController.queueSize)")
                self.checkDataConsistency()
            }
        }
    }
    
    func testPassAllTests() {
        while (true) {
            var nextWord = self.giveMeNextWord()
            self.checkDataConsistency()
            
            if nextWord == nil {
                XCTAssert(self.learnerController.wordsDueInFuture.count == self.learnerController.words.count, "all words should be in the future list")
                return
            } else if var nextTest = nextWord?.nextTest() {
                self.learnerController.onWordFinishedTestType(nextWord!, test: nextTest, testResult: .Pass)
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
    
    func firstWordDoneWithFirstTestAndResult(testResult: TestResult) -> (word: Word, testType: Test) {
        var firstWordToLearn = self.giveMeNextWord()
        var theTest: Test = firstWordToLearn!.nextTest()!
        self.learnerController.onWordFinishedTestType(firstWordToLearn!, test: theTest, testResult: testResult)
        
        return (firstWordToLearn!, theTest)
    }

    // #MARK: Performace
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
