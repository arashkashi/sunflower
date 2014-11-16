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
    var transactionManager: TransactionManager = TransactionManager.sharedInstance

    override func setUp() {
        super.setUp()
        self.creditManager.localBalance = 0
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTransactionCreation() {
        var transaction = Transaction(amount: 1000, type: TransactionType.grant_locallyNo_serverLazy)
        XCTAssertEqual(transaction.status, TransactionStatus.pending_server_write, "status is server write")
        
        transaction = Transaction(amount: 1000, type: TransactionType.grant_locallyNow_serverLazy)
        XCTAssertEqual(transaction.status, TransactionStatus.pending_server_local_write, "status is server AND local write")
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
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.commited, "status: commited")
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
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.pending_server_write, "status: pending")
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
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNow_serverLazy)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertTrue(success, "Transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "local balance check")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.commited, "status: commited")
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
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNow_serverLazy)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertTrue(success, "transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "local balance check")
            XCTAssertTrue(self.transactionManager.queue.includes(mockedTransaction), "should be queued")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.pending_server_write, "status: pending")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 5
    // Requirements: commit to server now or later (Lazy), dont commit locally
    // Condition: commit to server failed
    func testCaseFive() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit fails")
        
        class MockedTransaction: Transaction {
            private override func commitBETransation(beHandler: ((Bool) -> ())) {
                beHandler(false)
            }
        }
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNo_serverLazy)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertFalse(success, "Transaction fails")
            XCTAssertEqual(self.creditManager.localBalance, Int32(0), "local credit is not affected")
            XCTAssertTrue(self.transactionManager.queue.includes(mockedTransaction), "transaction is not removed from the queue")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.pending_server_write, "status: pending")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 6
    // Requirements: commit to server now or later (Lazy), dont commit locally
    // Condition: commit to server successed
    func testCaseSix() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit successeds")
        
        class MockedTransaction: Transaction {
            private override func commitBETransation(beHandler: ((Bool) -> ())) {
                beHandler(true)
            }
        }
        
        var mockedTransaction = MockedTransaction(amount: transactionAmount, type: .grant_locallyNo_serverLazy)
        
        mockedTransaction.commit { (success: Bool) -> () in
            XCTAssertTrue(success, "Transaction succeeds")
            XCTAssertEqual(self.creditManager.localBalance, Int32(0), "local credit is not affected")
            XCTAssertFalse(self.transactionManager.queue.includes(mockedTransaction), "transaction is  removed from the queue")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.commited, "status: commited")
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
