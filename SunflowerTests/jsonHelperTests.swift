//
//  jsonHelperTests.swift
//  Sunflower
//
//  Created by Arash Kashi on 20/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class jsonHelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReadListFromJson() {
        var result = JSONHelper.listFromJSONFile("pack_id_test")
        XCTAssert(result != nil , "Pass")
    }
    
    func testReadHashFromJson() {
        // TODO
        XCTAssert(true, "TODO")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
