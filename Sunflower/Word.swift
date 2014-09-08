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
    if lhs.learningDueDate == nil && rhs.learningDueDate == nil {
        return true
    }
    
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

class Word : Equatable {
    var name: String?
    var meaning: String?
    var currentLearningStage: LearningStage = LearningStage.Cram
    var learningDueDate: NSDate?
    var shouldShowWordPresentation: Bool = true
    var testsSuccessfulyDoneForCurrentStage: [TestType] = []
    
    init (name: String, meaning: String) {
        self.name = name
        self.meaning = meaning
    }
    
    func onWordFinishedTest(testType: TestType, testResult: TestResult) {
        if testResult == TestResult.Pass {
            self.testsSuccessfulyDoneForCurrentStage.append(testType)
        } else {
            self.testsSuccessfulyDoneForCurrentStage.removeAll(keepCapacity: false)
            self.currentLearningStage.decrement()
            self.shouldShowWordPresentation = true
        }
    }
    
    func onWordSuccessfullyFinishedAllTests() {
        self.currentLearningStage.increment()
        self.learningDueDate = Word.relearnDueDateForWordInALearningStage(self.currentLearningStage)
    }
    
    func onWordFinihsedPresentation() {
        self.shouldShowWordPresentation = false
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
    
    func hasDueDateInFuture() -> Bool {
        if self.learningDueDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return true
        } else {
            return false
        }
    }
    
    func isFinishedAllTestsForCurrentStage() -> Bool {
        for requiredTestType in Test.testSetForLearningStage(self.currentLearningStage) {
            if !contains(self.testsSuccessfulyDoneForCurrentStage, requiredTestType) {
                return false
            }
        }
        return true
    }
}
