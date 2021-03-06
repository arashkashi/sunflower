//
//  ParserHelper.swift
//  Sunflower
//
//  Created by Arash K. on 09/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


class ParserHelper {
    
    class func translatedWordsFromStringTokens(tokens: [String], sourceLanaguage: String, targetLanguage: String, googleTranslater: GoogleTranslate, completionHandler: ((words: [Word]?, err: String?)->())?) {
        var words: [Word] = []
        var countBadTranslations: Int = 0
        
        for token in tokens {
            googleTranslater.translate(token, targetLanguage: targetLanguage, sourceLanaguage: sourceLanaguage, successHandler: { (translations: [String]?, err: String?) -> () in
                
                // TODO: Never goes to this loop, fix the google translate class
                if err == ERR_GOOGLE_API_NETWORD_CONNECTION {
                    completionHandler?( words: words, err: "ERR_GOOGLE_API_NETWORD_CONNECTION!")
                    return
                }
                
                if translations != nil {
                    words.append(Word(name: token, meaning: ", ".join(translations!), sentences: []))
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