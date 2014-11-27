//
//  TestModel.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

enum TestType: Int32 {
    case Test1 = 1
    case Test2 = 2
    case TestTypeNil = 3
    
    func toInt() -> Int32 {
        switch self {
        case .Test1:
            return 1
        case .Test2:
            return 2
        default:
            assert(false, "not supperted")
            return 0
        }
    }
    
    func toString() -> String {
        switch self {
        case .Test1:
            return "Test1"
        case .Test2:
            return "Test2"
        default:
            assert(false, "not supperted")
            return "Test0"
        }
    }
    
    static func initWithInt(intInput: Int32) -> TestType {
        switch intInput {
        case 1:
            return .Test1
        case 2:
            return .Test2
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

class Test: NSObject, Equatable, NSCoding {
    var type: TestType
    
    init(testType: TestType) {
        self.type = testType
    }
    
    class func testSetForLearningStage(learningStage: LearningStage) -> [Test] {
        switch learningStage {
        case LearningStage.Cram:
            return [Test(testType: .Test1), Test(testType: .Test2)]
        case LearningStage.Learn:
            return [Test(testType: .Test2)]
        case LearningStage.Relearn:
            return [Test(testType: .Test1)]
        case LearningStage.Young:
            return [Test(testType: .Test2), Test(testType: .Test1)]
        case LearningStage.Mature:
            return [Test(testType: .Test2)]
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(self.type.toInt(), forKey: kTestType)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.type = TestType.initWithInt(aDecoder.decodeInt32ForKey(kTestType))
    }
}
