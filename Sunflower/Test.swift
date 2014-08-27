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

class Test {
    var type: TestType?
    
    class func testsForLearningStage(learningStage: LearningStage) -> [TestType] {
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
}
