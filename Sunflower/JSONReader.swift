//
//  JSONReader.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class JSONReader {
    
    class func readWordsFromJson() -> [Word] {
        var error: NSError?
        let filePath = NSBundle.mainBundle().pathForResource("words", ofType: "json")
        let jsonData: NSData = NSData.dataWithContentsOfFile(filePath, options: NSDataReadingOptions.DataReadingUncached, error: &error)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSDictionary
        let words = jsonResult.objectForKey("words") as NSArray
        
        var result: [Word] = [Word]()
        for wordDict in words as [NSDictionary] {
            var newWord = Word(name: wordDict["name"] as String, meaning: wordDict["meaning"] as String)
            result.append(newWord)
        }
        
        return result
    }
    
}
