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
        if var learntWordI = currentLearningQueue.first {
            if learntWordI.isDueInFuture() {
                self.addWordToFutureList(learntWordI)
                
                if var newDueWord = wordsDueNow.first {
                    self.wordsDueNow.removeAtIndex(0)
                    self.currentLearningQueue.insert(newDueWord, atIndex: 0)
                    return (insertLastItemInFirstAndReturnTheItem(&currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
                } else {
                    if !self.currentLearningQueue.isEmpty {
                        return (insertLastItemInFirstAndReturnTheItem(&currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
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
        if var learntWord = currentLearningQueue.first {
            if learntWord.shouldShowWordPresentation {
                return (learntWord, NextWordNilStatus.MORE_WORDS_TO_GO)
            }
        }
        
        // If current queue is not full, fill it up with ealierst dueNowWords member
        if self.currentLearningQueue.count < queueSize && wordsDueNow.count > 0 {
            var wordDueNow = wordsDueNow.first;
            self.wordsDueNow.removeAtIndex(0)
            self.currentLearningQueue.insert(wordDueNow!, atIndex: 0)
            return (wordDueNow, NextWordNilStatus.MORE_WORDS_TO_GO)
        }
        
        // If current queue is full, take the one from the buttom of list.
        if self.currentLearningQueue.count >= queueSize {
            return (self.insertLastItemInFirstAndReturnTheItem(&currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
        }
        
        if currentLearningQueue.count < queueSize && wordsDueNow.count == 0 {
            if currentLearningQueue.count == 0 && wordsDueInFuture.count == 0 {
                return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
            }
            
            if self.currentLearningQueue.count == 0 && wordsDueInFuture.count > 0 {
                return (nil, NextWordNilStatus.NO_MORE_WORD_TODAY)
            }
            
            if currentLearningQueue.count > 0 {
                return (insertLastItemInFirstAndReturnTheItem(&currentLearningQueue), NextWordNilStatus.MORE_WORDS_TO_GO)
            }
        }
        
        return (nil, NextWordNilStatus.ALL_WORDS_MASTERED)
    }
    
    func someRandomWords(number_of_words: Int, excludeList: [Word]) -> [Word] {
        var result: [Word] = []
        
        result = result + someWordsFromQueue(number_of_words, excludeList: excludeList, queue: currentLearningQueue)
        
        result = result + someWordsFromQueue(number_of_words - result.count, excludeList: excludeList, queue: self.wordsDueNow)
        
        result = result + someWordsFromQueue(number_of_words - result.count, excludeList: excludeList, queue: self.wordsDueInFuture)
        
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
            wordsDueInFuture = wordsDueInFuture.filter{$0 != word}
            wordsDueNow.append(word)
        }
        
        sort(&wordsDueNow, {(word1: Word, word2: Word) -> Bool in word1 < word2})
    }
    
    func addWordToFutureList(wordToBeAdded: Word) {
        // Remove from due now list
        wordsDueNow = wordsDueNow.filter({$0 != wordToBeAdded})

        // Remove from the current queue
        currentLearningQueue = currentLearningQueue.filter({$0 != wordToBeAdded})
        
        // Add to the future list
        wordsDueInFuture.append(wordToBeAdded)
        
        // Sort the future list
        sort(&wordsDueInFuture, {$0 < $1})
    }
    
    init (learningPack: LearningPackModel) {
        
        learningPackModel = learningPack
        
        queueTheWords()
    }
    
    func queueTheWords() {
        for word in learningPackModel.words as [Word] {
            if word.relearningDueDate == nil || word.relearningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                wordsDueNow.append(word)
            } else {
                wordsDueInFuture.append(word)
            }
        }
        
        sort(&wordsDueInFuture, {$0 < $1})
        sort(&wordsDueNow, {$0 < $1})
    }
    
    func updateLearningPackDocument() {
        self.learningPackModel.saveChanges()
    }
    
    //MARK: Events
    func onWordFinishedTestType(word: Word, test: Test, testResult: TestResult) {
        word.onWordFinishedTest(test, testResult: testResult)
        
        if word.isFinishedAllTestsForCurrentStage() {
            onWordSuccesssfullyFinishedAllTestsInLearningStage(word)
        }
        updateLearningPackDocument()
    }
    
    func onWordSuccesssfullyFinishedAllTestsInLearningStage(word: Word) {
        word.onWordSuccessfullyFinishedAllTests()
        updateLearningPackDocument()
    }
    
    func onWordFinishedPresentation(word: Word) {
        word.onWordFinihsedPresentation()
        updateLearningPackDocument()
    }
    
    func onWordSkipped(word: Word, handler: (()->())?) {
        // remove the word from the model
        learningPackModel.removeWord(word)
        
        // add it to the skipping model
        LearningPackControllerSkipHelper.loadSkipLearningPackModel { (skipModel: LearningPackModel?) -> () in
            if skipModel != nil {
                skipModel!.addWord(word)
            }
            handler?()
        }
        
        // remove from all queues
        currentLearningQueue = currentLearningQueue.filter {$0 != word}
        wordsDueNow = wordsDueNow.filter {$0 != word}
        wordsDueInFuture = wordsDueInFuture.filter {$0 != word}

        updateLearningPackDocument()
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
