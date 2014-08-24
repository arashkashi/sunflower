//
//  WordRetriever.swift
//  Sunflower
//
//  Created by Arash K. on 24/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class WordRetriever {
    class func retrieve() -> [Word] {
        var error: NSError?
        var jsonData: NSData = NSData .dataWithContentsOfFile("words.json", options: NSDataReadingOptions.DataReadingUncached, error: &error)

//        var object = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error: &error)
        
        
        
      return []
    }
}
