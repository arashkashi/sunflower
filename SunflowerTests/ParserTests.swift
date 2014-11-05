//
//  ParserTests.swift
//  Sunflower
//
//  Created by Arash K. on 03/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class ParserTests: XCTestCase {
    
    var inputText: String = "Nach der Schlappe der Demokraten von Präsident Obama bei den US-Kongresswahlen können die Republikaner nun die politische Agenda maßgeblich beeinflussen. Doch zwei Jahre Blockade können sie sich nicht leisten"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTokenise() {
        var tokens = Parser.tokenize(self.inputText)
        XCTAssert(tokens.count > 10, "Pass")
    }
    
    func testUniqueTokens() {
        var uniqueTokens = Parser.sortedUniqueTokensFor(self.inputText)
        XCTAssert(uniqueTokens.count > 0, "pass")
    }
    
    func testDictionarySort() {
        var dict = ["a":1, "b":600, "c":2, "d": 800]
        var sortedKeys = Parser.sortedKeysByValueFor(dict)
        XCTAssert(sortedKeys == ["a", "c", "b", "d"], "pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
