//
//  TestWords.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class TestWords {
    
    
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
        
        
        var result: Array<Word> = [Word]()
        for item: Dictionary<String, String> in rawWords {
            var name: String = item["name"]!
            var meaning: String = item["meaning"]!
            var newWord: Word = Word(name: name, meaning: meaning)
            result.append(newWord)
        }
        
        return result
    }
}
