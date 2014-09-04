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
    
    func testNoWordLearnt() {
        /* When no word has ever been learnt, just pick a random word from the set */
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)
        XCTAssert(nextWordToLearn != nil, "Next word should not be nil")
    }
    
    func testTwoWordsLearnsButNotDueForReLearnYet() {
        /* word1 : due to relearn in future
             word2 : due to relearn in future
             rest of the words : never has been learnt (cram)
             result: a random word from the [rest of the words] */
        var words :[Word] = self.learnerController.words
        var learntWord1: Word = words[0]
        var learntWord2: Word = words[1]
        
        learntWord1.learningDueDate = NSDate().dateByAddingTimeInterval(120)
        learntWord2.learningDueDate = NSDate().dateByAddingTimeInterval(300)
        
        self.learnerController.wordsDueInFuture.append(learntWord1)
        self.learnerController.wordsDueInFuture.append(learntWord2)
        
        self.learnerController.wordsNeverLearnt = self.learnerController.wordsNeverLearnt.filter { (word:Word) -> Bool in
            word.name != learntWord1.name && word.name != learntWord2.name
        }
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)
        XCTAssert(nextWordToLearn!.name != learntWord1.name, "Next word should not be words that are due in future")
        XCTAssert(nextWordToLearn!.name != learntWord2.name, "Next word should not be words that are due in future")
        XCTAssert(nextWordToLearn!.currentLearningStage == LearningStage.Cram, "next word is in the cram stage")
    }
    
    func testTwoWordsLearntOneIsDue() {
        /* word1: due to learn in past
             word2: due to learn in future
            rest of the words: never learnt (cram stage)
             result: word 1 */
        var words :[Word] = self.learnerController.words
        var learntWord1: Word = words[0]
        var learntWord2: Word = words[1]
        
        learntWord1.learningDueDate = NSDate().dateByAddingTimeInterval(-120)
        learntWord2.learningDueDate = NSDate().dateByAddingTimeInterval(300)
        
        self.learnerController.wordsDueInPast.append(learntWord1)
        self.learnerController.wordsDueInFuture.append(learntWord2)
        
        self.learnerController.wordsNeverLearnt = self.learnerController.wordsNeverLearnt.filter { (word:Word) -> Bool in
            word.name != learntWord1.name && word.name != learntWord2.name
        }

        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)
        
        XCTAssert(nextWordToLearn!.name == learntWord1.name, "Next word should one with pass learning due date")
    }
    
    func testTwoWordsAreDueForRelearnInPast() {
        /* word1: due to learn in past
             word2: due to learn in past (later past)
             rest of the words: never learnt (cram stage)
             result: word 2 */
        var words :[Word] = self.learnerController.words
        var learntWord1: Word = words[0]
        var learntWord2: Word = words[1]
        
        learntWord1.learningDueDate = NSDate().dateByAddingTimeInterval(-120)
        learntWord2.learningDueDate = NSDate().dateByAddingTimeInterval(-240)
        
        self.learnerController.wordsDueInPast.append(learntWord2)
        self.learnerController.wordsDueInPast.append(learntWord1)
        
        self.learnerController.wordsNeverLearnt = self.learnerController.wordsNeverLearnt.filter { (word:Word) -> Bool in
            word.name != learntWord1.name && word.name != learntWord2.name
        }
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)
        
        XCTAssert(nextWordToLearn!.name == learntWord2.name, "Next word should one with ealier due date")
    }
    
    func testTwoWordsAreDueForRelearnInFuture() {
        /* word1: due to learn in future
        word2: due to learn in future (later past)
        rest of the words: never learnt (cram stage)
        result: word 2 */
        var words :[Word] = self.learnerController.words
        var learntWord1: Word = words[0]
        var learntWord2: Word = words[1]
        
        learntWord1.learningDueDate = NSDate().dateByAddingTimeInterval(120)
        learntWord2.learningDueDate = NSDate().dateByAddingTimeInterval(240)
        
        self.learnerController.wordsDueInFuture.append(learntWord1)
        self.learnerController.wordsDueInFuture.append(learntWord2)
        
        self.learnerController.wordsNeverLearnt = self.learnerController.wordsNeverLearnt.filter { (word:Word) -> Bool in
            word.name != learntWord1.name && word.name != learntWord2.name
        }
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)
        
        XCTAssert(nextWordToLearn!.name != learntWord1.name, "Next word should not be one with future learning date")
        XCTAssert(nextWordToLearn!.name != learntWord2.name, "Next word should not be one with future learning date")
        
        XCTAssert(nextWordToLearn!.currentLearningStage == LearningStage.Cram, "next word is in the cram stage")
    }
    
    func testFutureWordGoingPass() {
        /* when learning there could be situations where the words in the future due become invalid, i.e.
                starting to go into the past, we should make sure that the next word resturns the right word */
        var words :[Word] = self.learnerController.words
        var learntWord1: Word = words[0]
        var learntWord2: Word = words[1]
        
        learntWord2.learningDueDate = NSDate().dateByAddingTimeInterval(-240)
        learntWord1.learningDueDate = NSDate().dateByAddingTimeInterval(-120)
        
        self.learnerController.wordsDueInFuture.append(learntWord2)
        self.learnerController.wordsDueInFuture.append(learntWord1)
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)
        XCTAssert(nextWordToLearn! == learntWord2, "even though in the future list, it have to move to the past list")
        XCTAssert(self.learnerController.wordsDueInPast[0] == learntWord2, "it should be in the past list")
        XCTAssert(self.learnerController.wordsDueInPast[1] == learntWord1, "second word")
        XCTAssert(self.learnerController.wordsDueInPast.count == 2, "should have two elements")

    }
    
    func testOnWordPassTest1() {
        /* when a word pass a test at cram mode
                1. The learning stage is updated
                2. The learning due date is updated
                3. It is removed from the wordsNeverLearnt/wordsDueInPast and put into wordsDueInFuture
            */
        var word: Word = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)!
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        
        XCTAssert(word.currentLearningStage == LearningStage.Learn, "Learning stage moves from Cram -> Learn")
        XCTAssert(word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending , "The due date for the newly learnt word is in future")
        XCTAssert(self.learnerController.relearnDueDateForWord(word.currentLearningStage)!.timeIntervalSinceDate(NSDate()) - word.learningDueDate!.timeIntervalSinceDate(NSDate()) < 10, "The future due date is set according to the new learning stage")
        XCTAssert(find(self.learnerController.wordsDueInFuture, word) != nil, "the word should be in the future relearns array")
    }
    
    func testOnWordPassTest2() {
        /* when a word pass a test at Learn stage 
            1. The learning stage is updated
            2. The learning due date isupdated
            3. It is removed from the wordsNeverLearnt/wordsDueInPast and put into wordsDueInFuture
          */
        var word: Word = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)!
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        
        XCTAssert(word.currentLearningStage == LearningStage.Young, "Learning stage moves from Cram -> Young after three times passing tests")
        XCTAssert(word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending , "The due date for the newly learnt word is in future")
        XCTAssert(self.learnerController.relearnDueDateForWord(word.currentLearningStage)!.timeIntervalSinceDate(NSDate()) - word.learningDueDate!.timeIntervalSinceDate(NSDate()) < 10, "The future due date is set according to the new learning stage")
        XCTAssert(find(self.learnerController.wordsDueInFuture, word) != nil, "the word should be in the future relearns array")
    }
    
    func testOnWordFailTest1() {
        /* when a word fail a test (two times) at Learn stage
            1. The learning stage is updated (moves one back -> decrement)
            2. The learning due date isupdated (put to the earliest past so the next word shown is the recently failed word
            3. It is removed from the wordsNeverLearnt/wordsDueInPast and put into wordsDueInPast
            4. The presentation flag should be set to true: so the word described before the next display
          */
        var word: Word = self.learnerController.nextWordToLearn(self.learnerController.wordsDueInFuture, pastList: self.learnerController.wordsDueInPast, neverLearntList: self.learnerController.wordsNeverLearnt)!
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordFailedTestSetForCurrentLearningStage(word)
        
        XCTAssert(word.currentLearningStage == LearningStage.Learn, "Learning stage moves from Cram -> Young after three times passing tests")
        XCTAssert(word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending , "The due date for the newly learnt word is in past")
        
        if self.learnerController.wordsDueInPast.count > 1 {
            XCTAssert(word.learningDueDate!.compare(self.learnerController.wordsDueInPast[1].learningDueDate!) == NSComparisonResult.OrderedAscending , "The due date for the newly learnt word is in past")
        }
        else {
            XCTAssert(word == self.learnerController.wordsDueInPast.first, "the failed word is the only member in the wordsDueInPast")
            XCTAssert(self.learnerController.wordsDueInPast.count == 1, "the failed word is the only member in the wordsDueInPast")
        }
        XCTAssert(find(self.learnerController.wordsDueInPast, word) != nil, "the word should be in the future relearns array")
        XCTAssert(word.shouldShowWordPresentation == true, "the presentation flag should be set to yes")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
