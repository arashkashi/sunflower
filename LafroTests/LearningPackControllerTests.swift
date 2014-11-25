//
//  LearningPackControllerTests.swift
//  Sunflower
//
//  Created by Arash K. on 23/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class LearningPackControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValidateID() {
        var learningPackController = LearningPackController.sharedInstance
        var result = learningPackController.validateID("1", existingIDs: ["1", "2", "iasdf"])
        XCTAssertEqual(result, "1I", "should add an 'I'")
        
        result = learningPackController.validateID("1", existingIDs: ["1", "1I", "iasdf"])
        XCTAssertEqual(result, "1II", "should add two 'II's")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
