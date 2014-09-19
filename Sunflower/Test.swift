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
    case Test2 = 2
    case Test3 = 3
    case Test4 = 4
    case TestTypeNil = 5
    
    func toInt() -> Int32 {
        switch self {
        case .Test1:
            return 1
        case .Test2:
            return 2
        case .Test3:
            return 3
        case .Test4:
            return 4
        default:
            assert(false, "not supperted")
            return 0
        }
    }
    
    func typeWithInt(intInput: Int) -> TestType {
        switch intInput {
        case 1:
            return .Test1
        case 2:
            return .Test2
        case 3:
            return .Test3
        case 4:
            return .Test4
        default:
            assert(false, "type not supported")
            return .TestTypeNil
        }
    }
}

enum TestResult: Int {
    case Pass = 1
    case Fail
}

func == (lhs: Test, rhs: Test) -> Bool {
    return lhs.type == rhs.type
}

let kTestType = "kTestType"

class Test: NSCoding {
    var type: TestType
    
    init(testType: TestType) {
        self.type = testType
    }
    
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
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(self.type.toInt(), forKey: kTestType)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeInt32ForKey(kTestType)
    }
}
