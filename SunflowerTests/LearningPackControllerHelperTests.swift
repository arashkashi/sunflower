//
//  LearningPackControllerHelperTests.swift
//  Sunflower
//
//  Created by Arash K. on 22/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class MockedGoogleTranslate: GoogleTranslate {
    override func translate(text: String, targetLanguage: String, sourceLanaguage: String, successHandler translateEndHandler: ((translation: String?, err: String?) -> ())?) {
        if text == "fail" {translateEndHandler!(translation: nil, err: "Force ERror")}
        else {
            translateEndHandler!(translation: "translation", err: nil)
        }
    }
}

class LearningPackControllerHelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTokensSuccessfullyConvertedToWords() {
        var tokens = ["token1","token2", "token3", "token4"]
        var word1 = Word(name: "token1", meaning: "token1", sentences: [])
        var word2 = Word(name: "token2", meaning: "token2", sentences: [])
        var result = LearningPackControllerHelper.tokensSuccessfullyConvertedToWords(tokens, words: [word1, word2])
        
        XCTAssertTrue(result.includes("token1"), "PASS")
        XCTAssertTrue(result.includes("token2"), "PASS")
        XCTAssertFalse(result.includes("token3"), "PASS")
        XCTAssertFalse(result.includes("token4"), "PASS")
    }
    
    func testTokensFailedConvertedToWords() {
        var tokens = ["token1","token2", "token3", "token4"]
        var word1 = Word(name: "token1", meaning: "token1", sentences: [])
        var word2 = Word(name: "token2", meaning: "token2", sentences: [])
        
        var result = LearningPackControllerHelper.tokensFailedConvertedToWords(tokens, words: [word1, word2])
        
        XCTAssertFalse(result.includes("token1"), "PASS")
        XCTAssertFalse(result.includes("token2"), "PASS")
        XCTAssertTrue(result.includes("token3"), "PASS")
        XCTAssertTrue(result.includes("token4"), "PASS")
    }
    
    func testMakeWordsFromTokens() {
        var expectation = expectationWithDescription("should finish translation")

        var selectedLanaguge = "selectedlanguage"
        var sourceLanguage = "sourceLangague"
        var manager: MockedGoogleTranslate =  MockedGoogleTranslate()
        var tokens = ["fail", "fail", "success_kiarash", "fail", "success_arsah"]
        
        LearningPackControllerHelper.makeWordsFromTokens(tokens, sourceLanguage: sourceLanguage, selectedLanguage: selectedLanaguge, googleTransaltor: manager, handler: { (words: [Word]?, error: NSError?) -> () in
            XCTAssertTrue(words!.count == 2, "")

            expectation.fulfill()
        })

        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
