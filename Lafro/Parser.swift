//
//  Parser.swift
//  Sunflower
//
//  Created by Arash K. on 03/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


class Parser {
    
    class var sharedInstance : Parser {
        struct Static {
            static let instance : Parser = Parser()
        }
        return Static.instance
    }
    
    // MARK: API
    class func sortedUniqueTokensFor(text: String) -> [String] {
        var tokens = Parser.tokenize(text)
        var tokenDict = Parser.distDictFor(tokens)
        var sortedTokens = Parser.sortedKeysByValueFor(tokenDict)
        return sortedTokens.filter{$0 != ""}
    }
    
    // MARK: Helper
    class func tokenize(inputText: String) -> [String]{
        var tokens = inputText.componentsSeparatedByString(" ")
        return tokens
    }
    
    class func distDictFor(tokens: [String]) -> [String: Int] {
        var distribution = Dictionary<String, Int>()
        for token in tokens {
            if distribution[token] == nil {
                distribution[token] = 0
            } else {
                distribution[token] = distribution[token]! + 1
            }
        }
        return distribution
    }
    
    class func sortedKeysByValueFor(dict: Dictionary<String, Int>)  -> [String]{
        
        var tuples: [(String, Int)] = map(dict) {(key, value) in (key, value)}
        tuples.sort { $0.1 > $1.1 }
        
        var result: [String] = []
        for (word, count) in tuples {
            result.append(word)
        }
        
        return result
    }
}
