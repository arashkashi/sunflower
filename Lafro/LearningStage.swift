//
//  LearningStage.swift
//  Sunflower
//
//  Created by Arash Kashi on 04/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

func < (lhs: LearningStage, rhs: LearningStage) -> Bool {
    return lhs.toInt() < rhs.toInt()
}

func != (lhs: LearningStage, rhs: LearningStage) -> Bool {
    return lhs.toInt() != rhs.toInt()
}

enum LearningStage: Int32, Comparable {
    case Intro = 1
    case Cram
    case Learn
    case Relearn
    case Young
    case Mature
    
    static func allStages() -> [LearningStage] {
        return [.Intro, .Cram, .Learn, .Relearn, .Young, .Mature]
    }
    
    mutating func reset() {
        self = .Intro
    }
    
    mutating func increment() {
        switch self {
        case .Intro:
            self = .Cram
        case .Cram:
            self = Learn
        case .Learn:
            self = Relearn
        case .Relearn:
            self = Young
        case .Young:
            self = Mature
        case .Mature:
            self = Mature
        default:
            self = Cram
        }
    }
    
    mutating func decrement() {
        switch self {
        case .Intro:
            self = Intro
        case .Cram:
            self = Intro
        case .Learn:
            self = Cram
        case .Relearn:
            self = Learn
        case .Young:
            self = Relearn
        case .Mature:
            self = Young
        default:
            self = Cram
        }
    }
    
    func toInt () -> Int32 {
        switch self {
        case .Intro:
            return 1
        case .Cram:
            return 2
        case .Learn:
            return 3
        case .Relearn:
            return 4
        case .Young:
            return 5
        case .Mature:
            return 6
        }
    }
    
    static func initWithInt(intInput: Int32) -> LearningStage {
        switch intInput {
        case 1:
            return .Intro
        case 2:
            return .Cram
        case 3:
            return .Learn
        case 4:
            return .Relearn
        case 5:
            return .Young
        case 6:
            return .Mature
        default:
            assert(false, "type is not supported")
            return .Cram
        }
    }
    
    func toString () -> String {
        switch self {
        case .Intro:
            return "Intro"
        case .Cram:
            return "Cram"
        case .Learn:
            return "Learn"
        case .Relearn:
            return "Relearn"
        case .Young:
            return "Young"
        case .Mature:
            return "Mature"
        }
    }
}