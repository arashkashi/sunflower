//
//  Word.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

let kName = "kName"
let kMeaning = "kName"
let kLearningStage = "kLeaningStage"
let kLearningDueDate = "kLearningDueDate"
let kShouldShowPresentation = "kShouldShowPresentation"
let kTestsSuccessfullyDone = "kTestsSuccessfulllyDone"

func == (lhs: Word, rhs: Word) -> Bool {
    return lhs.name == rhs.name
}

func < (lhs: Word, rhs: Word) -> Bool {
    if lhs.learningDueDate == nil && rhs.learningDueDate == nil {
        return false
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
        } else if rhs.learningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return false
        }
    }
    
    return lhs.learningDueDate!.compare(rhs.learningDueDate!) == NSComparisonResult.OrderedAscending
}

class Word : Equatable, Printable, DebugPrintable, NSCoding {
    var name: String
    var meaning: String
    var currentLearningStage: LearningStage = LearningStage.Cram
    var learningDueDate: NSDate?
    var shouldShowWordPresentation: Bool = true
    var testsSuccessfulyDoneForCurrentStage: [Test] = []
    
    var description: String { get {return self.name}}
    var debugDescription: String { get {return self.name}}
    
    init (name: String, meaning: String) {
        self.name = name
        self.meaning = meaning
    }
    
    func onWordFinishedTest(test: Test, testResult: TestResult) {
        if testResult == TestResult.Pass {
            self.testsSuccessfulyDoneForCurrentStage.append(test)
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
    
    func isDueInFuture() -> Bool {
        if self.learningDueDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return true
        } else {
            return false
        }
    }
    
    func isDueInPast() -> Bool {
        if self.learningDueDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return true
        } else {
            return false
        }
    }
    
    func isFinishedAllTestsForCurrentStage() -> Bool {
        for requiredTestType in Test.testSetForLearningStage(self.currentLearningStage) {
            // FIXME: Uncomment
//            if contains(self.testsSuccessfulyDoneForCurrentStage, requiredTestType) {
//                return false
//            }
        }
        return true
    }
    
    func nextTest() -> Test? {
        for test in Test.testSetForLearningStage(self.currentLearningStage) {
             // FIXME: Uncomment
//            if !contains(self.testsSuccessfulyDoneForCurrentStage, test) {
//                return test
//            }
        }
        return nil
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: kName)
        aCoder.encodeObject(self.meaning, forKey: kMeaning)
        if let learningDue = self.learningDueDate { aCoder.encodeObject(learningDue, forKey: kLearningDueDate)}
        aCoder.encodeObject(self.currentLearningStage.toInt(), forKey: kLearningStage)
        aCoder.encodeObject(self.testsSuccessfulyDoneForCurrentStage, forKey: kTestsSuccessfullyDone)
        aCoder.encodeBool(self.shouldShowWordPresentation, forKey: kShouldShowPresentation)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey(kName) as String
        self.meaning = aDecoder.decodeObjectForKey(kMeaning) as String
        self.learningDueDate = aDecoder.decodeObjectForKey(kLearningDueDate)? as? NSDate
        self.currentLearningStage = LearningStage.initWithInt(aDecoder.decodeInt32ForKey(kLearningStage) as Int32)
        
    }
}
