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
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn()
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
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn()
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

        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn()
        
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
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn()
        
        XCTAssert(nextWordToLearn!.name == learntWord2.name, "Next word should one with ealier due date")
    }
    
    func testTwoWordsAreDueForRelearnInFuture() {
        /* word1: due to learn in past
        word2: due to learn in past (later past)
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
        
        var nextWordToLearn: Word? = self.learnerController.nextWordToLearn()
        
        XCTAssert(nextWordToLearn!.name != learntWord1.name, "Next word should not be one with future learning date")
        XCTAssert(nextWordToLearn!.name != learntWord2.name, "Next word should not be one with future learning date")
        
        XCTAssert(nextWordToLearn!.currentLearningStage == LearningStage.Cram, "next word is in the cram stage")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
