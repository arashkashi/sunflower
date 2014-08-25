//
//  LearnerController.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class LearnerController {
    var words: [Word]?;
    
    func nextWordToLearn() -> Word {
        var result: Word;
        result = Word(name: "test", meaning: "test")
        return result;
    }
    
    func sortedWords(words: [Word]) {
        reversed = sort(words, { (word1: Word, word2: Word) -> Bool in
            
            if word1.learningDueDate == nil || word2.learningDueDate ==nil
        return s1 > s2
        })
        
    }
    
    func onWordPassTest(word: Word) {
        word.currentLearningStage.incrementStage()
        word.learningDueDate = self.relearnDueDateForWord(word.currentLearningStage)
    }
    
    func onWordFailedTest(word: Word) {
        word.currentLearningStage.decrement()
        word.learningDueDate = self.relearnDueDateForWord(word.currentLearningStage)
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
    }
}
