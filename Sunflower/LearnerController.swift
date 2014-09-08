//
//  LearnerController.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation
import UIKit

enum NextWordNilStatus: Int {
    case NO_WORD_TODAY = 1
    case ALL_WORDS_MASTERED = 2
    case MORE_WORDS_TO_GO = 3
}

class LearnerController {
    var words: [Word];
    var wordsDueInFuture: [Word] = []
    var wordsDueNow: [Word] = []
    var currentLearningQueue: [Word] = []
    
    let queueSize: Int = 2
    
    func nextWordToLearn(inout futureList: [Word], inout dueNowWords: [Word], inout currentQueue: [Word]) -> (Word?, NextWordNilStatus) {
        // If words in future are due now, move them to the due now list
        self.refreshWithFutureList(&futureList, dueNowList: &dueNowWords)
        
        // If the current queue has a word which has a learning due date in future, 
        // instead of putting it in the button of the list, put it into the future list
        // and its place put an item from the due now list and then take one word from 
        // the button and put it onto the top.
        if (currentQueue.first?.hasDueDateInFuture() != nil) {
            var learntWord = currentQueue.first!
            self.addWordToFutureList(learntWord)
            
            if var newDueWord = dueNowWords.first? {
                dueNowWords.filter({$0 != newDueWord})
                currentQueue.insert(newDueWord, atIndex: 0)
                return (self.insertLastItemInFirstAndReturnTheItem(&currentQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
            } else {
                if futureList.isEmpty {
                    return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
                } else {
                    return (nil, NextWordNilStatus.NO_WORD_TODAY)
                }
            }
        }

        
        // If current queue has a word for presentation on top, present it.
        if (currentQueue.first?.shouldShowWordPresentation != nil) {
            return (currentQueue.first!, NextWordNilStatus.MORE_WORDS_TO_GO)
        }
        
        // If current queue is not full, fill it up with ealierst dueNowWords member
        if currentQueue.count < self.queueSize && dueNowWords.count > 0 {
            var wordDueNow = dueNowWords.first;
            currentQueue.insert(wordDueNow!, atIndex: 0)
            dueNowWords.filter({$0 != wordDueNow})
            return (wordDueNow, NextWordNilStatus.MORE_WORDS_TO_GO)
        }
        
        // If current queue is full, take the one from the buttom of list.
        if currentQueue.count >= self.queueSize {
            return (self.insertLastItemInFirstAndReturnTheItem(&currentQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
        }
        
        if currentQueue.count < self.queueSize && dueNowWords.count == 0 {
            if currentQueue.count == 0 && futureList.count == 0 {
                return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
            }
            
            if currentQueue.count == 0 && futureList.count > 0 {
                return (nil, NextWordNilStatus.NO_WORD_TODAY)
            }
            
            if currentQueue.count > 0 {
                return (self.insertLastItemInFirstAndReturnTheItem(&currentQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
            }
        }
        
        return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
    }
    
    func insertLastItemInFirstAndReturnTheItem(inout list: [Word]) -> Word {
        var lastWord = list.last
        list.filter({$0 != lastWord})
        list.insert(lastWord!, atIndex: 0)
        return lastWord!
    }
    
    func refreshWithFutureList(inout futureList: [Word], inout dueNowList:[Word]) {
        var wordsWereInFutureDueNow: [Word] = []
        
        for word in futureList as [Word] {
            if word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                wordsWereInFutureDueNow.append(word)
            } else {
                break
            }
        }
        
        for word in wordsWereInFutureDueNow {
            futureList = futureList.filter{$0 != word}
            dueNowList.append(word)
        }
        
        sort(&dueNowList, {(word1: Word, word2: Word) -> Bool in word1 < word2})
    }
    
    func addWordToFutureList(wordToBeAdded: Word) {
        // Remove from due now list
        self.wordsDueNow.filter({$0 != wordToBeAdded})

        // Remove from the current queue
        self.currentLearningQueue.filter({$0 != wordToBeAdded})
        
        // Add to the future list
        self.wordsDueInFuture.append(wordToBeAdded)
        
        // Sort the future list
        sort(&self.wordsDueInFuture, {$0 < $1})
    }
    
    init (words:[Word]) {
        self.words = words
        
        for word in self.words as [Word] {
            if word.learningDueDate == nil || word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                self.wordsDueNow.append(word)
            } else {
                self.wordsDueInFuture.append(word)
            }
        }
        
        sort(&self.wordsDueInFuture, {$0 < $1})
        sort(&self.wordsDueNow, {$0 < $1})
    }
    
    func onWordFinishedTestType(word: Word, testType: TestType, testResult: TestResult) {
        word.onWordFinishedTest(testType, testResult: testResult)
        
        if word.isFinishedAllTestsForCurrentStage() {
            self.onWordSuccesssfullyFinishedAllTestsInLearningStage(word)
        }
    }
    
    func onWordSuccesssfullyFinishedAllTestsInLearningStage(word: Word) {
        word.onWordSuccessfullyFinishedAllTests()
    }
    
    func onWordFinishedPresentation(word: Word) {
        word.onWordFinihsedPresentation()
    }
    

}
