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
        var filePath = NSBundle.mainBundle().pathForResource("Package-1_translated", ofType: "json")
        var jsonDATA = NSData.dataWithContentsOfFile(filePath!, options: .DataReadingMappedIfSafe, error: nil)
        var package = NSJSONSerialization.JSONObjectWithData(jsonDATA!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? Dictionary
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
            var newWord: Word = Word(name: name, meaning: meaning)
            result.append(newWord)
        }
        
        return result
    }

}
