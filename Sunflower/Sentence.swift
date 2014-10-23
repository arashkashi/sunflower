//
//  Sentence.swift
//  Sunflower
//
//  Created by Arash Kashi on 20/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kOriginalSentence = "kOriginalSentence"
let kTranslatedSentence = "kTranslatedSentence"

import Foundation

class Sentence : NSObject, NSCoding {
    var original: String
    var translated: String
    
    init(original: String, translated: String) {
        self.original = original
        self.translated = translated
    }
    
    // MARK: Helper
    class func sentencesFromArrays(sourceSentences: [String], targetSentences: [String]) -> [Sentence] {
        assert(sourceSentences.count == targetSentences.count, "all sentences have translation")
        var result: [Sentence] = []
        
        for (index, item) in enumerate(sourceSentences) {
            var sentence = Sentence(original: item, translated: targetSentences[index])
            result.append(sentence)
        }
        
        return result
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.original, forKey: kOriginalSentence)
        aCoder.encodeObject(self.translated, forKey: kTranslatedSentence)
    }
    
    required init(coder aDecoder: NSCoder) {
        if let original = aDecoder.decodeObjectForKey(kOriginalSentence) as? NSString {
            self.original = original as String
        } else {
            assert(false, "ERROR: could not decode")
            self.original = "ERROR"
        }
        
        if let translated = aDecoder.decodeObjectForKey(kTranslatedSentence) as? NSString {
            self.translated = translated as String
        } else {
            assert(false, "ERROR: could not decode")
            self.translated = "ERROR"
        }
    }
}


