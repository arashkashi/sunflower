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
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)
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
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)
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

        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)
        
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
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)
        
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
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)
        
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
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)
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
        var word: Word = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)!
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        
        XCTAssert(word.currentLearningStage == LearningStage.Learn, "Learning stage moves from Cram -> Learn")
        XCTAssert(word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending , "The due date for the newly learnt word is in future")
        XCTAssert(Word.relearnDueDateForWordInALearningStage(word.currentLearningStage)!.timeIntervalSinceDate(NSDate()) - word.learningDueDate!.timeIntervalSinceDate(NSDate()) < 10, "The future due date is set according to the new learning stage")
        XCTAssert(find(self.learnerController.wordsDueInFuture, word) != nil, "the word should be in the future relearns array")
    }
    
    func testOnWordPassTest2() {
        /* when a word pass a test at Learn stage 
            1. The learning stage is updated
            2. The learning due date isupdated
            3. It is removed from the wordsNeverLearnt/wordsDueInPast and put into wordsDueInFuture
          */
        var word: Word = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)!
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        
        XCTAssert(word.currentLearningStage == LearningStage.Young, "Learning stage moves from Cram -> Young after three times passing tests")
        XCTAssert(word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending , "The due date for the newly learnt word is in future")
        XCTAssert(Word.relearnDueDateForWordInALearningStage(word.currentLearningStage)!.timeIntervalSinceDate(NSDate()) - word.learningDueDate!.timeIntervalSinceDate(NSDate()) < 10, "The future due date is set according to the new learning stage")
        XCTAssert(find(self.learnerController.wordsDueInFuture, word) != nil, "the word should be in the future relearns array")
    }
    
    func testOnWordFailTest1() {
        /* when a word first passes twp tests and fail the 3rd one
            1. The learning stage is updated (two increment and one decrement)
            2. The learning due date is updated (when passes go to next learning stage and dues date is set accordingly, when failes go to previous learning stage and the due date is updated accordingly.
            3. It is removed from the wordsNeverLearnt/wordsDueInPast and put into wordsDueInPast
            4. The presentation flag should be set to true: so the word described before the next display
          */
        var word: Word = self.learnerController.nextWordToLearn(&self.learnerController.wordsDueInFuture, pastList: &self.learnerController.wordsDueInPast)!
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordPassAllTestSetForCurrentLearningStage(word)
        self.learnerController.onWordFailedTestSetForCurrentLearningStage(word)

        XCTAssert(find(self.learnerController.wordsDueInPast, word) != nil, "the word should be in the past relearns array")
        XCTAssert(word.shouldShowWordPresentation == true, "the presentation flag should be set to yes")
        
        XCTAssert(word.currentLearningStage == LearningStage.Learn, "Learning stage moves from Cram -> Young after three times passing tests")
        XCTAssert(word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending , "The due date for the newly learnt word is in past")
    }
    
    func testScheduleWordCase1() {
//        // when the wordsDueInPast list is empty
//        // 1. Add it to the wordsDueInPast.
//        // 2. set the learning date in the past
//        var words :[Word] = self.learnerController.words
//        var learntWord1: Word = words[0]
//        
//        self.learnerController.schduleForNextTestAfterANumberOfRounds(learntWord1, numberOFTurnsAhead: 0)
//        
//        XCTAssert(self.learnerController.wordsDueInPast.count == 1, "there should be one word in the list")
//        XCTAssert(self.learnerController.wordsDueInPast[0] == learntWord1, "it should be the word scheduled")
//        XCTAssert(self.learnerController.wordsDueInPast[0].learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending, "its due date should be in the past")
        
    }
    
    func testScheduleWordCase2() {
        // when wordsDueInPast list has one item
        // 1. test for order 1 and order 0
        
        var words :[Word] = self.learnerController.words
        var learntWord1: Word = words[0]
        var learntWord2: Word = words[1]
        
        learntWord2.learningDueDate = NSDate().dateByAddingTimeInterval(-500)
        learntWord1.learningDueDate = NSDate().dateByAddingTimeInterval(-1000)
        
        self.learnerController.wordsDueInPast.append(learntWord1)
        self.learnerController.wordsDueInPast.append(learntWord2)
        
        XCTAssert(false, "description")
    }
    
    func testScheduleWordCase3() {
        // when wordsDueInPast list has two items
        // 1. test for order 2 and order 1 and 0
        
        XCTAssert(false, "description")
    }
    
    func testScheduleWordCase4() {
        // when wordsDueInPast list has three items
        // 1. test for order 3 and order 2 and 1 and 0
        
        XCTAssert(false, "description")
    }
    
    func testAddWordtoFutureListWhenFutureListEmpty() {
        var words :[Word] = self.learnerController.words
        var learntWord3: Word = words[3]
        
        learntWord3.learningDueDate = NSDate().dateByAddingTimeInterval(180)
        self.learnerController.addWordToFutureList(learntWord3, currentFutureList: self.learnerController.wordsDueInFuture)
        XCTAssert(self.learnerController.wordsDueInFuture[0] == learntWord3, "the word 3 should be in the middle of the list")
    }
    
    func testWordComparison() {
        var word1 = Word(name: "futureword1", meaning: "futuremeaning1")
        word1.learningDueDate = NSDate().dateByAddingTimeInterval(10)
        
        var word2 = Word(name: "pastword2", meaning: "pastmeaning2")
        word2.learningDueDate = NSDate().dateByAddingTimeInterval(-10)
        
        var word3 = Word(name: "noDueword3", meaning: "noDuemeaning3")
        
        XCTAssert(word2 < word1, "")
        XCTAssert(word3 < word1, "")
        XCTAssert(word2 < word3, "")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
