//
//  TestWords.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class TestLearningPackI: LearningPackModel {
    
    class func instance() -> LearningPackModel {
        var result = LearningPackModel(id: TestLearningPackIDI, words: TestLearningPackI.words())
        result.id = TestLearningPackIDI
        return result
    }
    
    class func words() -> Array<Word> {
        var rawWords =  [
            ["name":"schwangerschaft","meaning":"pregnancy"],
            ["name":"verhütung","meaning":"averting"],
            ["name":"mittel","meaning":"means"],
            ["name":"rind","meaning":"cattle"],
            ["name":"etikettierung","meaning":"labelling"],
            ["name":"Aufgaben","meaning":"duties"],
            ["name":"Übertragun","meaning":"assignment"],
            ["name":"Gesetz","meaning":"Gesetz"],
            ["name":"schaden","meaning":"schaden"],
            ["name":"freude","meaning":"joy"]
        ]
        
        var result: [Word] = []
        for item: Dictionary<String, String> in rawWords {
            var name: String = item["name"]!
            var meaning: String = item["meaning"]!
            var newWord: Word = Word(name: name, meaning: meaning, sentences: [])
            result.append(newWord)
        }
        
        return result
    }

}

let kPackName = "kname"
let kPackMeaning = "kmeaning"
let kPackSampleSentences = "ksampleSentences"
let kPackTranslatedSampleSentences = "kTranslatedSampleSentences"

class RawPackage {
    
    class func packWithID(id: String) -> LearningPackModel! {
        var filename = RawPackage.jsonFileNameFromID(id)
        
        if let hashOfWords = JSONHelper.hashFromJSONFile(filename) {
            for word in hashOfWords.allKeys as [String] {
                var name = word
                var meaning = hashOfWords.objectForKey(word)!.objectForKey(kPackMeaning)! as String
                var raw_sentences: [String] = (hashOfWords[word]! as NSDictionary )[kPackSampleSentences]
                var translated_sentences: [String] = hashOfWords[word]![kPackTranslatedSampleSentences]!
//                var senteces = Sentence.sentencesFromArrays(hashOfWords[word]![kPackSampleSentences]!, targetSentences: ) as [Sentence]
                
//                Word(name: name, meaning:meaning, sentences: senteces)
                
                
            }
            
        }
        
    }
    
    class func jsonFileNameFromID(id: String) -> String {
        return "pack_\(id).json"
    }
}
