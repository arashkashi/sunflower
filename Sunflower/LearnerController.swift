//
//  LearnerController.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation
import UIKit

class LearnerController {
    var words: [Word];
    var wordsNeverLearnt: [Word] = [Word]()
    var wordsDueInFuture: [Word] = [Word]()
    var wordsDueInPast: [Word] = [Word]()
    
    func nextWordToLearn(futureList: [Word], pastList: [Word], neverLearntList: [Word]) -> Word? {
        self.refreshWithFutureList(futureList, pastList: pastList)
        
        var wordToRelearn: Word? = self.wordsDueInPast.first
        if (wordToRelearn != nil) {
            return wordToRelearn!
        }
        
        return neverLearntList.first?
    }
    
    func onWordFinishedTestType(word: Word, testType: TestType, testResult: TestResult) {
        if testResult == TestResult.Pass {
            word.testsSuccessfulyDoneForCurrentStage.append(testType)
        }
        
        if testResult == TestResult.Fail {
            
        }
    }
    
    func refreshWithFutureList(futureList: [Word], pastList:[Word]) -> (resultingFutureList: [Word], resultingPastList: [Word]){
        var wordsToPutBackInPastDue: [Word] = []
        var newFutureList: [Word] = futureList
        var newPastList: [Word] = pastList
        
        for word in newFutureList as [Word] {
            if word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                wordsToPutBackInPastDue.append(word)
            } else {
                break
            }
        }
        
        for word in wordsToPutBackInPastDue {
            newFutureList = newFutureList.filter{$0 != word}
            newPastList.append(word)
        }
        
        self.wordsDueInFuture = newFutureList
        self.wordsDueInPast = newPastList
        
        return (newFutureList, newPastList)
    }
    
    func schduleForNextTestAfterANumberOfRounds(word: Word, numberOFTurnsAhead: Int) {
//        self.removeWordFromAllLists(word)
//        
//        // First look into into the words in the past
//        if self.wordsDueInPast.count >= numberOFTurnsAhead {
//            self.wordsDueInPast.insert(word, atIndex: numberOFTurnsAhead - 2)
//        } else if self.wordsNeverLearnt.count >= numberOFTurnsAhead {
//            self.wordsNeverLearnt.insert(word, atIndex: num)
//        }
//        
//        // Second Look into the words in the Future
//        
//        // third look into words never learnt
    }
    
    func onWordPassAllTestSetForCurrentLearningStage(word: Word) {
        word.onPassAllTestSetForCurrentStage()
        self.removeWordFromAllLists(word)
        self.addWordToFutureList(word, currentFutureList: self.wordsDueInFuture)
    }
    
    func onWordFailedTestSetForCurrentLearningStage(word: Word) {
        word.onFailTestSetForCurrentStage()
        self.removeWordFromAllLists(word)
        self.wordsDueInPast.insert(word, atIndex: 0)
    }
    
    func addWordToFutureList(wordToBeAdded: Word, currentFutureList: [Word]) -> [Word] {
        var newFutureList: [Word] = currentFutureList
        var indexToBeAdded: Int?
        
        for (index, wordItem: Word) in enumerate(newFutureList)  {
            if index == 0 && wordToBeAdded < wordItem {
                indexToBeAdded = 0
                break
            }
            
            if index != newFutureList.count - 1 && wordToBeAdded > wordItem && wordToBeAdded < newFutureList[index + 1] {
                indexToBeAdded = index + 1
                break;
            }
            
            if index == newFutureList.count - 1 && wordToBeAdded > wordItem {
                indexToBeAdded = index + 1
                break;
            }
        }
        
        if indexToBeAdded == nil {
            indexToBeAdded = 0
        }
        
        newFutureList.insert(wordToBeAdded, atIndex: indexToBeAdded!)
        
        self.wordsDueInFuture = newFutureList
        return newFutureList
    }
    
    func relearnDueDateForFailedTest(word: Word) -> NSDate {
        if self.wordsDueInPast.count > 0 {
            return self.wordsDueInPast.first!.learningDueDate!.dateByAddingTimeInterval(-20)
        } else {
            return NSDate().dateByAddingTimeInterval(-20)
        }
    }
    
    func removeWordFromAllLists(word: Word) {
        self.wordsNeverLearnt = self.wordsNeverLearnt.filter({ (wordInList: Word) -> Bool in
            wordInList != word
        })
        self.wordsDueInPast = self.wordsDueInPast.filter({ (wordInList: Word) -> Bool in
            wordInList != word
        })
        self.wordsDueInFuture = self.wordsDueInFuture.filter({ (wordInList: Word) -> Bool in
            wordInList != word
        })
    }
    
    func shouldShowWordPresentation(word: Word) -> Bool
    {
        if word.currentLearningStage == LearningStage.Cram || word.shouldShowWordPresentation {
            return true
        } else {
            return false
        }
    }
    
    init (words:[Word]) {
        self.words = words
        
        for word in self.words as [Word] {
            if word.learningDueDate == nil {
                self.wordsNeverLearnt.append(word)
            } else if (word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending) {
                self.wordsDueInPast.append(word)
            } else {
                self.wordsDueInFuture.append(word)
            }
        }
        
        sort(&self.wordsDueInFuture, {(word1: Word, word2: Word) -> Bool in word1.learningDueDate!.compare(word2.learningDueDate!) == NSComparisonResult.OrderedAscending})
        sort(&self.wordsDueInPast, {(word1: Word, word2: Word) -> Bool in word1.learningDueDate!.compare(word2.learningDueDate!) == NSComparisonResult.OrderedAscending})
    }
}
