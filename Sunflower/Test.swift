//
//  TestModel.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

enum TestType: Int {
    case Test1 = 1
    case Test2
    case Test3
    case Test4
}

enum TestResult: Int {
    case Pass = 1
    case Fail
}

enum TestSetResult: Int {
    case pass = 1
    case Fail
}

class Test {
    var type: TestType?
    
    class func testSetForLearningStage(learningStage: LearningStage) -> [TestType] {
        switch learningStage {
        case LearningStage.Cram:
            return [TestType.Test1, TestType.Test2]
        case LearningStage.Learn:
            return [TestType.Test1, TestType.Test2]
        case LearningStage.Relearn:
            return [TestType.Test2, TestType.Test3]
        case LearningStage.Young:
            return [TestType.Test2, TestType.Test3]
        case LearningStage.Mature:
            return [TestType.Test2, TestType.Test3]
        }
    }
    
    // WARNING: Write Test case for this methos
    class func nextTestFor(leaningState: LearningStage, lastPassedTest: TestType?) -> TestType? {
        // If no tests is done before, return the first test
        if lastPassedTest == nil { return Test.testSetForLearningStage(leaningState)[0] }
        
        var testSet : [TestType] = Test.testSetForLearningStage(leaningState)
        
        for (index, item) in enumerate(testSet) {
            var testType: TestType = item as TestType
            if testType == lastPassedTest && testSet.last != testType {
                return testSet[index + 1]
            }
        }
        return nil
    }
}
