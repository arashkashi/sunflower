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
    case NO_MORE_WORD_TODAY = 1
    case ALL_WORDS_MASTERED = 2
    case MORE_WORDS_TO_GO = 3
}

class LearnerController {
    var words: [Word];
    var wordsDueInFuture: [Word] = []
    var wordsDueNow: [Word] = []
    var currentLearningQueue: [Word] = []
    
    var learningPackModel: LearningPackModel
    
    let queueSize: Int = 4
    
    // This is the only method that operates on the three following variables
    // 1. wordsDueInFuture
    // 2. wordsDueNow
    // 3. currentLearningQueue
    func nextWordToLearn() -> (word: Word?, status: NextWordNilStatus) {
        // If words in future are due now, move them to the due now list
        self.moveToDueNowFromFutureListIfApplicable()
        
        // If the current queue has a word which has a learning due date in future, 
        // instead of putting it in the button of the list, put it into the future list
        // and its place, put an item from the due now list and then take one word from
        // the button and put it onto the top.
        if var learntWordI = self.currentLearningQueue.first? {
            if learntWordI.isDueInFuture() {
                self.addWordToFutureList(learntWordI)
                
                if var newDueWord = self.wordsDueNow.first? {
                    self.wordsDueNow.removeAtIndex(0)
                    self.currentLearningQueue.insert(newDueWord, atIndex: 0)
                    return (self.insertLastItemInFirstAndReturnTheItem(&self.currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
                } else {
                    if !self.currentLearningQueue.isEmpty {
                        return (self.insertLastItemInFirstAndReturnTheItem(&self.currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
                    }
                    if self.wordsDueInFuture.isEmpty {
                        return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
                    } else {
                        return (nil, NextWordNilStatus.NO_MORE_WORD_TODAY)
                    }
                }
            }
        }
        
        // If current queue has a word for presentation on top, present it.
        if var learntWord = self.currentLearningQueue.first? {
            if learntWord.shouldShowWordPresentation {
                return (learntWord, NextWordNilStatus.MORE_WORDS_TO_GO)
            }
        }
        
        // If current queue is not full, fill it up with ealierst dueNowWords member
        if self.currentLearningQueue.count < self.queueSize && self.wordsDueNow.count > 0 {
            var wordDueNow = self.wordsDueNow.first;
            self.wordsDueNow.removeAtIndex(0)
            self.currentLearningQueue.insert(wordDueNow!, atIndex: 0)
            return (wordDueNow, NextWordNilStatus.MORE_WORDS_TO_GO)
        }
        
        // If current queue is full, take the one from the buttom of list.
        if self.currentLearningQueue.count >= self.queueSize {
            return (self.insertLastItemInFirstAndReturnTheItem(&self.currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
        }
        
        if self.currentLearningQueue.count < self.queueSize && self.wordsDueNow.count == 0 {
            if self.currentLearningQueue.count == 0 && self.wordsDueInFuture.count == 0 {
                return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
            }
            
            if self.currentLearningQueue.count == 0 && self.wordsDueInFuture.count > 0 {
                return (nil, NextWordNilStatus.NO_MORE_WORD_TODAY)
            }
            
            if self.currentLearningQueue.count > 0 {
                return (self.insertLastItemInFirstAndReturnTheItem(&self.currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
            }
        }
        
        return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
    }
    
    func someRandomWords(number_of_words: Int, excludeList: [Word]) -> [Word] {
        var result: [Word] = []
        
        result = result + self.someWordsFromQueue(number_of_words, excludeList: excludeList, queue: self.currentLearningQueue)
//        println("\(result.count) -> \(self.currentLearningQueue.count)")
        
        result = result + self.someWordsFromQueue(number_of_words - result.count, excludeList: excludeList, queue: self.wordsDueNow)
//        println("\(result.count) -> \(self.wordsDueNow.count)")
        
        result = result + self.someWordsFromQueue(number_of_words - result.count, excludeList: excludeList, queue: self.wordsDueInFuture)
//        println("\(result.count) -> \(self.wordsDueInFuture.count)")
        
        assert(result.count == number_of_words, "PASS")
        
        return result
    }
    
    func insertLastItemInFirstAndReturnTheItem(inout list: [Word]) -> Word {
        var lastWord = list.last
        list.removeLast()
        list.insert(lastWord!, atIndex: 0)
        return lastWord!
    }
    
    func moveToDueNowFromFutureListIfApplicable() {
        var wordsWereInFutureDueNow: [Word] = []
        
        for word in self.wordsDueInFuture as [Word] {
            if word.relearningDueDate!.isPast() {
                wordsWereInFutureDueNow.append(word)
            } else {
                break
            }
        }
        
        for word in wordsWereInFutureDueNow {
            self.wordsDueInFuture = self.wordsDueInFuture.filter{$0 != word}
            self.wordsDueNow.append(word)
        }
        
        sort(&self.wordsDueNow, {(word1: Word, word2: Word) -> Bool in word1 < word2})
    }
    
    func addWordToFutureList(wordToBeAdded: Word) {
        // Remove from due now list
        self.wordsDueNow = self.wordsDueNow.filter({$0 != wordToBeAdded})

        // Remove from the current queue
        self.currentLearningQueue = self.currentLearningQueue.filter({$0 != wordToBeAdded})
        
        // Add to the future list
        self.wordsDueInFuture.append(wordToBeAdded)
        
        // Sort the future list
        sort(&self.wordsDueInFuture, {$0 < $1})
    }
    
    init (learningPack: LearningPackModel) {
        
        self.words = learningPack.words
        self.learningPackModel = learningPack
        
        queueTheWords()
    }
    
    func queueTheWords() {
        for word in self.words as [Word] {
            if word.relearningDueDate == nil || word.relearningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                self.wordsDueNow.append(word)
            } else {
                self.wordsDueInFuture.append(word)
            }
        }
        
        sort(&self.wordsDueInFuture, {$0 < $1})
        sort(&self.wordsDueNow, {$0 < $1})
    }
    
    func updateLearningPackDocument() {
        self.learningPackModel.saveChanges()
    }
    
    //MARK: Events
    func onWordFinishedTestType(word: Word, test: Test, testResult: TestResult) {
        word.onWordFinishedTest(test, testResult: testResult)
        
        if word.isFinishedAllTestsForCurrentStage() {
            self.onWordSuccesssfullyFinishedAllTestsInLearningStage(word)
        }
        self.updateLearningPackDocument()
    }
    
    func onWordSuccesssfullyFinishedAllTestsInLearningStage(word: Word) {
        word.onWordSuccessfullyFinishedAllTests()
        self.updateLearningPackDocument()
    }
    
    func onWordFinishedPresentation(word: Word) {
        word.onWordFinihsedPresentation()
        self.updateLearningPackDocument()
    }
    
    func onWordSkipped(word: Word, handler: (()->())?) {
        // remove the word from the model
        self.learningPackModel.removeWord(word)
        
        // add it to the skipping model
        LearningPackControllerSkipHelper.loadSkipLearningPackModel { (skipModel: LearningPackModel?) -> () in
            if skipModel != nil {
                skipModel!.addWord(word)
            }
            handler?()
        }
        
        // remove from all queues
        self.currentLearningQueue = self.currentLearningQueue.filter {$0 != word}
        self.wordsDueNow = self.wordsDueNow.filter {$0 != word}
        self.wordsDueInFuture = self.wordsDueInFuture.filter {$0 != word}

        self.updateLearningPackDocument()
    }
    
    // MARK: Helper
    func someWordsFromQueue(number_of_words: Int, excludeList: [Word], queue: [Word]) -> [Word] {
        var result: [Word] = []
        if number_of_words <= 0 { return result }
        for word in queue {
            if !excludeList.includes(word) {
                result.append(word)
            }
            if result.count == number_of_words { break }
        }
        return result
    }
    
    class func printWord(word: Word?, index: Int = 0) {
        if let printedWord = word {
            println("\(index)---------------------------")
            println("Name: \(printedWord.name)")
            println("Meaning: \(printedWord.meaning)")
            println("Learning Due Date:\(printedWord.relearningDueDate)")
            println("Next Test Type: \(printedWord.nextTest()?.type.toString())")
            println("Learning Stage: \(word?.currentLearningStage.toString())")
            println("Tests done:")
            for test in printedWord.testsSuccessfulyDoneForCurrentStage {
                println("\t \(test.type.toString())")
            }
        } else {
            println("THE GIVEN WORD IN NIL")
        }
        println("----------------------------------------")
    }
    
    class func printListOfWords(words: [Word]) {
        println("****************************************************** \(words.count)")
        for (index, word) in enumerate(words) {
            LearnerController.printWord(word, index: index)
        }
        println()
        println("******************************************************")
        
    }
}
