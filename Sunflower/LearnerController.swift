//
//  LearnerController.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class LearnerController {
    var words: [Word];
    var wordsNeverLearnt: [Word] = [Word]()
    var wordsDueInFuture: [Word] = [Word]()
    var wordsDueInPast: [Word] = [Word]()
    
    func nextWordToLearn() -> Word? {
        var wordToRelearn: Word? = self.wordsDueInPast.first
        if (wordToRelearn != nil) {
            return wordToRelearn!
        } else {
            return wordsNeverLearnt.first
        }
    }
    
    func onWordPassTest(word: Word) {
        word.currentLearningStage.incrementStage()
        word.learningDueDate = self.relearnDueDateForWord(word.currentLearningStage)
        self.onFinishingTestingWord(word)
    }
    
    func onWordFailedTest(word: Word) {
        word.currentLearningStage.decrement()
        word.learningDueDate = self.relearnDueDateForWord(word.currentLearningStage)
        self.onFinishingTestingWord(word)
    }
    
    func onFinishingTestingWord(word: Word) {
        self.removeWordFromAllLists(word)
        self.wordsDueInFuture.append(word) // TODO: find where to add the word
    }
    
    func removeWordFromAllLists(word: Word) {
        self.wordsNeverLearnt = self.wordsNeverLearnt.filter({ (wordInList: Word) -> Bool in
            wordInList.name != word.name
        })
        self.wordsDueInPast = self.wordsDueInPast.filter({ (wordInList: Word) -> Bool in
            wordInList.name != word.name
        })
        self.wordsDueInFuture = self.wordsDueInFuture.filter({ (wordInList: Word) -> Bool in
            wordInList.name != word.name
        })
    }
    
    func relearnDueDateForWord(learningStage: LearningStage) -> NSDate? {
        switch learningStage {
        case LearningStage.Cram:
            return NSDate().dateByAddingTimeInterval(60)            // 1 minute
        case LearningStage.Learn:
            return NSDate().dateByAddingTimeInterval(20 * 60)       // 20 minute
        case LearningStage.Relearn:
            return NSDate().dateByAddingTimeInterval(60 * 60)       // 60 minute
        case LearningStage.Young:
            return NSDate().dateByAddingTimeInterval(9 * 60 * 60)   // 9 hours
        case LearningStage.Mature:
            return nil
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
