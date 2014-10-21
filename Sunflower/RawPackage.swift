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
    
    class func packWithID(id: String) -> [Word] {
        var words: [Word] = []
        var filename = RawPackage.jsonFileNameFromID(id)
        
        if let hashOfWords = JSONHelper.hashFromJSONFile(filename) {
            for word in hashOfWords.allKeys as [String] {
                var name = word
                var meaning = hashOfWords[word]![kPackMeaning]! as String
                var raw_sentences: [String] = hashOfWords[word]![kPackSampleSentences]! as [String]
                var translated_sentences: [String] = hashOfWords[word]![kPackTranslatedSampleSentences]! as [String]
                var senteces = Sentence.sentencesFromArrays(raw_sentences, targetSentences: translated_sentences) as [Sentence]
                var word = Word(name: name, meaning:meaning, sentences: senteces)
                words.append(word)
            }
        }
        return words
    }
    
    class func jsonFileNameFromID(id: String) -> String {
        return "pack_id_\(id)"
    }
}
