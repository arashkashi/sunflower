//
//  Word.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

enum LearningStage: Int8 {
    case Cram = 1
    case Learn
    case Relearn
    case Young
    case Mature
    
    mutating func incrementStage() {
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
}

func == (lhs: Word, rhs: Word) -> Bool {
    return lhs.name == rhs.name
}

class Word : Equatable {
    var name: String?
    var meaning: String?
    var currentLearningStage: LearningStage = LearningStage.Cram
    var learningDueDate: NSDate?
    
    init (name: String, meaning: String) {
        self.name = name
        self.meaning = meaning
    }
}
