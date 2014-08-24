//
//  Word.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

enum LearningStage: Int32 {
    case Cram = 1
    case Learn
    case Relearn
    case Young
    case Mature
}


class Word {
    var name: String?
    var meaning: String?
    var currentLearningStage: LearningStage = LearningStage.Cram
    var learningDueDate: NSDate?
    
    init (name: String, meaning: String) {
        self.name = name
        self.meaning = meaning
    }

}
