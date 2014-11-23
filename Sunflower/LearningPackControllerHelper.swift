//
//  LearningPackControllerHelper.swift
//  Sunflower
//
//  Created by Arash K. on 22/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation



class LearningPackControllerHelper  {
    class func makeLearningPackModelWithTransaction(id: String, tokens: [String], corpus: String, sourceLanguage: String, selectedLanguage: String, finishHandler: ((LearningPackModel?)->())? ) {
        LearningPackControllerHelper.makeWordsFromTokensWithTransation(tokens, corpus: corpus, sourceLanguage: sourceLanguage, selectedLanguage: selectedLanguage, transactionManager: TransactionManager.sharedInstance, googleTranslator: GoogleTranslate.sharedInstance) { (success: Bool, words: [Word]?, error: NSError?) -> () in
            if success && words != nil {
                var packController = LearningPackController.sharedInstance
                var existingIDS = packController.listOfAvialablePackIDs
                var validatedID = LearningPackController.sharedInstance.validateID(id, existingIDs: existingIDS)
                LearningPackController.sharedInstance.addNewPackage(validatedID, words: words!, corpus: corpus, completionHandlerForPersistance: { (success: Bool, model: LearningPackModel?) -> () in
                    if success && model != nil {
                        finishHandler?(model!)
                    } else {
                        finishHandler?(nil)
                    }
                })
            }
        }
    }
    
    class func makeWordsFromTokensWithTransation(tokens: [String], corpus: String, sourceLanguage: String, selectedLanguage: String, transactionManager: TransactionManager, googleTranslator: GoogleTranslate, completionHandler: ((Bool, [Word]?, NSError?)->())) {
        // Calcalte the cost of all tokens successully translated
        var totalCost = GoogleTranslate.sharedInstance.costToTranslate(tokens)
        
        // Make the transaction for all the token,
        transactionManager.createAndCommitTransaction(-1 * totalCost, type: .grant_locallyNow_serverNow) { (commitResult) -> () in
            // Failed?, fail the entire operation
            if commitResult == .Failed { completionHandler(false, nil, NSError(domain: "Cloudkit", code: 1001, userInfo: nil)) }
            else
            {
                LearningPackControllerHelper.makeWordsFromTokens(tokens, sourceLanguage: sourceLanguage, selectedLanguage: selectedLanguage, googleTransaltor: googleTranslator, handler: { (wordsResult: [Word]?, errors: NSError?) -> () in
                    if wordsResult == nil {
                        // if there is no word, refund the user
                        TransactionManager.sharedInstance.createAndCommitTransaction(totalCost, type: .grant_locallyNow_serverLazy, handler: nil)
                        completionHandler(false, nil, NSError(domain: "make words from tokens", code: 1002, userInfo: nil))
                    } else {
                        var failedTokens = LearningPackControllerHelper.tokensFailedConvertedToWords(tokens, words: wordsResult!)
                        var costToBeRefunded = GoogleTranslate.sharedInstance.costToTranslate(failedTokens)
                        TransactionManager.sharedInstance.createAndCommitTransaction(costToBeRefunded, type: .grant_locallyNow_serverLazy, handler: nil)
                        completionHandler(true, wordsResult, NSError(domain: "make words from tokens", code: 1002, userInfo: nil))
                    }
                })
            }
        }
    }
    
    class func makeWordsFromTokens(tokens: [String], sourceLanguage: String, selectedLanguage: String, googleTransaltor: GoogleTranslate, handler: ([Word]?, NSError?) -> () ) {
        var countBadTranslations: Int = 0
        var words: [Word] = []
        
        // To the translation for all the tokens and create the resulting words
        for token in tokens {
            googleTransaltor.translate(token, targetLanguage: selectedLanguage, sourceLanaguage: sourceLanguage, successHandler: { (translation, err) -> () in
            
                if translation != nil {
                    words.append(Word(name: token, meaning: translation!, sentences: []))
                } else {
                    countBadTranslations++
                }
                
                if words.count == (tokens.count - countBadTranslations) {
                    handler(words, nil)
                }
            })
        }        
    }
    
    class func tokensSuccessfullyConvertedToWords(tokens: [String], words: [Word]) -> [String] {
        var wordtokens = words.map { $0.name }
        var result: [String] = []
        for token in tokens {
            if wordtokens.includes(token) { result.append(token) }
        }
        
        return result
    }
    
    class func tokensFailedConvertedToWords(tokens: [String], words: [Word]) -> [String] {
        var wordtokens = words.map { $0.name }
        var result: [String] = []
        for token in tokens {
            if !wordtokens.includes(token) { result.append(token) }
        }
        
        return result
    }
    
}
