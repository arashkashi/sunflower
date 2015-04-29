//
//  TestWords.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

let kPackMeaning = "meaning"
let kPackSampleSentences = "sample_sentences"
let kPackTranslatedSampleSentences = "translated_sample_sentence"

class RawPackage {
    
    class func packWithID(id: String) -> [Word]? {
        var words: [Word] = []
        var filename = RawPackage.jsonFileNameFromID(id)
        
        if let jsonWords = JSONHelper.listFromJSONFile(filename) {
            for hashWord in jsonWords as! [NSDictionary] {
                var name = hashWord.allKeys[0] as! String
                var meaning = hashWord.objectForKey(name)?.objectForKey(kPackMeaning) as! String
                var raw_sentences = hashWord.objectForKey(name)?.objectForKey(kPackSampleSentences) as! [String]
                var translated_sentences: [String] = hashWord.objectForKey(name)?.objectForKey(kPackTranslatedSampleSentences) as! [String]
                var senteces = Sentence.sentencesFromArrays(raw_sentences, targetSentences: translated_sentences) as [Sentence]
                var word: Word = Word(name: name, meaning:meaning, sentences: senteces)
                words.append(word)
            }
            
            return words
        } else {
            return nil
        }
    }
    
    class func jsonFileNameFromID(id: String) -> String {
        return "pack_id_\(id)"
    }
}
