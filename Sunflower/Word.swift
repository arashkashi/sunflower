//
//  Word.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

let kName = "kName"
let kMeaning = "kMeaning"
let kLearningStage = "kLeaningStage"
let kPrevLEarningStage = "kPrevLearningStage"
let kLearningDueDate = "kLearningDueDate"
let kShouldShowPresentation = "kShouldShowPresentation"
let kTestsSuccessfullyDone = "kTestsSuccessfulllyDone"
let kSentences = "kSentences"

func == (lhs: Word, rhs: Word) -> Bool {
    return lhs.name == rhs.name
}

func < (lhs: Word, rhs: Word) -> Bool {
    if lhs.relearningDueDate == nil && rhs.relearningDueDate == nil {
        return false
    }
    
    if lhs.relearningDueDate != nil && rhs.relearningDueDate == nil {
        if lhs.relearningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return true
        } else if lhs.relearningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return false
        }
    }
    
    if lhs.relearningDueDate == nil && rhs.relearningDueDate != nil {
        if rhs.relearningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return true
        } else if rhs.relearningDueDate!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return false
        }
    }
    
    return lhs.relearningDueDate!.compare(rhs.relearningDueDate!) == NSComparisonResult.OrderedAscending
}

class Word : NSObject, Equatable, Printable, DebugPrintable, NSCoding {
    var name: String
    var meaning: String
    
    var sentences: [Sentence]
    
    var currentLearningStage: LearningStage = .Cram {
        didSet {
            if currentLearningStage != oldValue {
                self.prevLearningStage = oldValue
            }
        }
    }
    
    var prevLearningStage: LearningStage = .Cram
    
    var relearningDueDate: NSDate?
    var shouldShowWordPresentation: Bool = true
    var testsSuccessfulyDoneForCurrentStage: [Test] = []
    
    override var description: String { get {return self.name}}
    override var debugDescription: String { get {return self.name}}
    
    init (name: String, meaning: String, sentences: [Sentence]) {
        self.name = name
        self.meaning = meaning
        self.sentences = sentences
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
        self.relearningDueDate = Word.relearnDueDateForWordInALearningStage(self.currentLearningStage)
        self.testsSuccessfulyDoneForCurrentStage.removeAll(keepCapacity: false)
    }
    
    func onWordFinihsedPresentation() {
        self.shouldShowWordPresentation = false
    }
    
    class func relearnDueDateForWordInALearningStage(learningStage: LearningStage) -> NSDate? {
        switch learningStage {
        case LearningStage.Cram:
            return NSDate().dateByAddingTimeInterval(60)            // 1 minute
        case LearningStage.Learn:
            return NSDate().dateByAddingTimeInterval(2 * 60)       // 20 minute
        case LearningStage.Relearn:
            return NSDate().dateByAddingTimeInterval(60 * 60)       // 60 minute
        case LearningStage.Young:
            return NSDate().dateByAddingTimeInterval(9 * 60 * 60)   // 9 hours
        case LearningStage.Mature:
            return nil
        }
    }
    
    func isDueInFuture() -> Bool {
        if self.relearningDueDate?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return true
        } else {
            return false
        }
    }
    
    func isDueInPast() -> Bool {
        if self.relearningDueDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return true
        } else {
            return false
        }
    }
    
    func isFinishedAllTestsForCurrentStage() -> Bool {
        return self.nextTest() == nil
    }
    
    func nextTest() -> Test? {
        for testToBeDone in Test.testSetForLearningStage(self.currentLearningStage) {
            if !self.testsSuccessfulyDoneForCurrentStage.includes(testToBeDone) {
                return testToBeDone
            }
        }
        return nil
    }
    
    // MARK: Helper
    func printToSTD() {
        println("-----------------START----------------")
        println("Name: \(self.name)")
        println("Learning Due Date:\(self.relearningDueDate)")
        println("Next Test Type: \(self.nextTest()?.type.toString())")
        println("Learning Stage: \(self.currentLearningStage.toString())")
        println("Tests done:")
        for test in self.testsSuccessfulyDoneForCurrentStage {
            println("\t \(test.type.toString())")
        }
        println("----------------END--------------------")
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: kName)
        aCoder.encodeObject(self.meaning, forKey: kMeaning)
        if let learningDue = self.relearningDueDate { aCoder.encodeObject(learningDue, forKey: kLearningDueDate)}
        aCoder.encodeInt32(self.currentLearningStage.toInt(), forKey: kLearningStage)
        aCoder.encodeInt32(self.prevLearningStage.toInt(), forKey: kPrevLEarningStage)
        aCoder.encodeObject(self.testsSuccessfulyDoneForCurrentStage, forKey: kTestsSuccessfullyDone)
        aCoder.encodeBool(self.shouldShowWordPresentation, forKey: kShouldShowPresentation)
        aCoder.encodeObject(self.sentences, forKey: kSentences)
    }
    
    required init(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObjectForKey(kName) as? NSString {
            self.name = name as String
        } else {
            assert(false, "ERROR: could not decode")
            self.name = "ERROR"
        }
        
        if let meaning = aDecoder.decodeObjectForKey(kMeaning) as? NSString {
            self.meaning = meaning as String
        } else {
            assert(false, "ERROR: could not decode")
            self.meaning = "ERROR"
        }
        
        self.relearningDueDate = aDecoder.decodeObjectForKey(kLearningDueDate) as? NSDate
        self.currentLearningStage = LearningStage.initWithInt(aDecoder.decodeInt32ForKey(kLearningStage) as Int32)
        self.prevLearningStage = LearningStage.initWithInt(aDecoder.decodeInt32ForKey(kPrevLEarningStage) as Int32)
        self.testsSuccessfulyDoneForCurrentStage = aDecoder.decodeObjectForKey(kTestsSuccessfullyDone) as [Test]
        self.shouldShowWordPresentation = aDecoder.decodeBoolForKey(kShouldShowPresentation)
        self.sentences = aDecoder.decodeObjectForKey(kSentences) as [Sentence]
    }
}
