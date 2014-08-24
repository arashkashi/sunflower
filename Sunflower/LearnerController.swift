//
//  LearnerController.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class LearnerController {
    var words: [Word]?;
    
    func nextWordToLearn() -> Word {
        var result: Word;
        
        result = Word(name: "test", meaning: "test")
        
        return result;
    }
    
    init (words:[Word]) {
        self.words = words
    }
}
