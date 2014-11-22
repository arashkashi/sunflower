//
//  ParserHelper.swift
//  Sunflower
//
//  Created by Arash K. on 09/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


class ParserHelper {
    
    class func translatedWordsFromStringTokens(tokens: [String], sourceLanaguage: String, targetLanguage: String, completionHandler: ((words: [Word]?, err: String?)->())?) {
        var words: [Word] = []
        var countBadTranslations: Int = 0
        
        for token in tokens {
            GoogleTranslate.sharedInstance.translate(token, targetLanguage: targetLanguage, sourceLanaguage: sourceLanaguage, translateEndHandler: { (translation: String?, err: String?, cost: Lafru) -> () in
                
                if err == ERR_GOOGLE_API_NETWORD_CONNECTION {
                    completionHandler?( words: words, err: "ERR_GOOGLE_API_NETWORD_CONNECTION!")
                    return
                }
                
                if translation != nil && translation != "" {
                    words.append(Word(name: token, meaning: translation!, sentences: []))
                } else {
                    countBadTranslations++
                }
                
                if words.count == tokens.count - countBadTranslations {
                    completionHandler?(words: words, err: nil)
                }
            })
        }
    }
}