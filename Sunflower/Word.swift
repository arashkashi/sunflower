//
//  Word.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

func == (lhs: Word, rhs: Word) -> Bool {
    return lhs.name == rhs.name
}

func < (lhs: Word, rhs: Word) -> Bool {
    if lhs.learningDueDate != nil && rhs.learningDueDate == nil {
        if lhs.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return true
        } else if lhs.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return false
        }
    }
    
    if lhs.learningDueDate == nil && rhs.learningDueDate != nil {
        if rhs.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return true
        } else if lhs.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return false
        }
    }
    
    return lhs.learningDueDate!.compare(rhs.learningDueDate!) == NSComparisonResult.OrderedAscending
}

class Word : Equatable, Printable{
    var name: String?
    var meaning: String?
    var currentLearningStage: LearningStage = LearningStage.Cram
    var learningDueDate: NSDate?
    var shouldShowWordPresentation: Bool = true
    var testsSuccessfulyDoneForCurrentStage: [TestType] = []
    
    var description: String {
        return "WordType: \(self.name), \(self.learningDueDate?)"
    }
    
    init (name: String, meaning: String) {
        self.name = name
        self.meaning = meaning
    }
    
    func onPassAllTestSetForCurrentStage() {
        self.currentLearningStage.increment()
        self.learningDueDate = Word.relearnDueDateForWordInALearningStage(self.currentLearningStage)
    }
    
    func onFailTestSetForCurrentStage() {
        self.currentLearningStage.decrement()
        self.learningDueDate = Word.relearnDueDateForWordInALearningStage(self.currentLearningStage)
        self.shouldShowWordPresentation = true
    }
    
    class func relearnDueDateForWordInALearningStage(learningStage: LearningStage) -> NSDate? {
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
}
