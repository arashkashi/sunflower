//
//  CloudKitManagerTests.swift
//  Sunflower
//
//  Created by Arash K. on 12/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import XCTest

class CloudKitManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func writeUserReecordExample() {
        // This is an example of a functional test case.
        let expectation = expectationWithDescription("Wait for CloukitResponse")
        
        var manager = CloudKitManager.sharedInstance
        manager.fetchUserRecordID { (recordID, err) -> Void in
            //
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: { error in
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
