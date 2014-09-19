//
//  LearningStage.swift
//  Sunflower
//
//  Created by Arash Kashi on 04/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


enum LearningStage: Int32 {
    case Cram = 1
    case Learn
    case Relearn
    case Young
    case Mature
    
    mutating func increment() {
        switch self {
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
        case .Cram:
            self = Cram
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
    
    func toInt () -> Int {
        switch self {
        case .Cram:
            return 1
        case .Learn:
            return 2
        case .Relearn:
            return 3
        case .Young:
            return 4
        case .Mature:
            return 5
        }
    }
    
    mutating func fromInt(int: Int) {
        switch int {
        case 1:
            self = Cram
        case 2:
            self = Cram
        case 3:
            self = Learn
        case 4:
            self = Relearn
        case 5:
            self = Young
        default:
            self = Cram
        }
    }
    
    func toString () -> String {
        switch self {
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