//
//  LearningPackControllerHelperTests.swift
//  Sunflower
//
//  Created by Arash K. on 22/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import XCTest

//class MockedGoogleTransate: GoogleTranslate {
//    override func translate(text: String, targetLanguage: String, sourceLanaguage: String, translateEndHandler: ((translation: String?, err: String?, cost: Lafru) -> ())?) {
//        if text == "fail" { translateEndHandler!(nil, "mockedError", 10) }
//        else { translateEndHandler!("translated", nil, 10) }
//    }
//}

class LearningPackControllerHelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Case one
    func testMakeWordsFromTokensCaseOne() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
