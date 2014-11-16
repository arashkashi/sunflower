//
//  TransactionTests.swift
//  Sunflower
//
//  Created by Arash K. on 16/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest
import Foundation

class TransactionTests: XCTestCase {
    
    var creditManager: CreditManager = CreditManager.sharedInstance

    override func setUp() {
        super.setUp()
        self.creditManager.localBalance = 0
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // Case 1
    // Requirements: commit to server now, commit locally now
    // Condition: Both successful
    func testcaseOne() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit success")
        
        class MockedTransaction: Transaction {
            private override func commitBETransation(beHandler: ((Bool) -> ())) {
                beHandler(true)
            }
        }
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNow_serverNow)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertTrue(success, "transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "Credit Manager should be loaded")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 2
    // Requirements: commit ro server now, commit locally now
    // Condition: commit to server fails
    func testCaseTwo() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit fails")
        
        class MockedTransaction: Transaction {
            private override func commitBETransation(beHandler: ((Bool) -> ())) {
                beHandler(false)
            }
        }
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNow_serverNow)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertFalse(success, "Transaction fails")
            XCTAssertEqual(self.creditManager.localBalance, Int32(0), "local balance should not change")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 3
    // Requirements: commit to server now or later (Lazy), commit locally now
    // Condition: commit to server successful
    func testCaseThree() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit success")
        
        class MockedTransaction: Transaction {
            private override func commitBETransation(beHandler: ((Bool) -> ())) {
                beHandler(true)
            }
        }
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNow_serverNowOrLater)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertTrue(success, "Transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "local balance check")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 4
    // Requirements: commit to server now or later (Lazy), commit locally now
    // Condition: commit to server failed
    func testCaseFour() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit fails")
        
        class MockedTransaction: Transaction {
            private override func commitBETransation(beHandler: ((Bool) -> ())) {
                beHandler(false)
            }
        }
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNow_serverNowOrLater)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertTrue(success, "transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "local balance check")
            expectation.fulfill()
        }
        
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
