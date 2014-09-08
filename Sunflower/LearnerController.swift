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
    var wordsDueInFuture: [Word] = [Word]()
    var wordsDueInPast: [Word] = [Word]()
    
    func nextWordToLearn(inout futureList: [Word], inout pastList: [Word]) -> Word? {
        self.refreshWithFutureList(&futureList, pastList: &pastList)
        
        var wordToRelearn: Word? = self.wordsDueInPast.first
        
        return wordToRelearn?
    }
    
    func onWordFinishedTestType(word: Word, testType: TestType, testResult: TestResult) {
        if testResult == TestResult.Pass {
            word.testsSuccessfulyDoneForCurrentStage.append(testType)
        }
        
        if testResult == TestResult.Fail {
            
        }
    }
    
    func refreshWithFutureList(inout futureList: [Word], inout pastList:[Word]) -> (resultingFutureList: [Word], resultingPastList: [Word]){
        var wordsToPutBackInPastDue: [Word] = []
        
        for word in futureList as [Word] {
            if word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                wordsToPutBackInPastDue.append(word)
            } else {
                break
            }
        }
        
        for word in wordsToPutBackInPastDue {
            futureList = futureList.filter{$0 != word}
            self.enqueueInThePastDueList(word, wordsListDuePast:&pastList)
        }
        
        return (futureList, pastList)
    }
    
    func enqueueInThePastDueList(word: Word, inout wordsListDuePast: [Word]) -> [Word] {
        wordsListDuePast.append(word)
        sort(&wordsListDuePast, {$0 < $1})
        return wordsListDuePast
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
    
    func schduleWordForFutureTest(word: Word, wordsDueInPast: [Word], order: Int) {
        
    }
    
    func addWordToFutureList(wordToBeAdded: Word, currentFutureList: [Word]) -> [Word] {
        var newFutureList: [Word] = currentFutureList
        var indexToBeAdded: Int?
        
        for (index, wordItem: Word) in enumerate(newFutureList)  {
            if index == 0 && wordToBeAdded < wordItem {
                indexToBeAdded = 0
                break
            }
            
            if index != newFutureList.count - 1 && wordItem < wordToBeAdded && wordToBeAdded < newFutureList[index + 1] {
                indexToBeAdded = index + 1
                break;
            }
            
            if index == newFutureList.count - 1 && wordItem < wordToBeAdded{
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
            if word.learningDueDate == nil || word.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                self.wordsDueInPast.append(word)
            } else {
                self.wordsDueInFuture.append(word)
            }
        }
        
        sort(&self.wordsDueInFuture, {(word1: Word, word2: Word) -> Bool in word1 < word2})
        sort(&self.wordsDueInPast, {(word1: Word, word2: Word) -> Bool in word1 < word2})
    }
}
