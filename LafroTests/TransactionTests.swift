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

class MockedTransactionWithSucessfulServerTransaction: Transaction {
     override func commitServerTransation(beHandler: ((Bool) -> ())) {
        beHandler(true)
    }
}

class MockedTransactionWithFailedServerTransaction: Transaction {
     override func commitServerTransation(beHandler: ((Bool) -> ())) {
        beHandler(false)
    }
}

class TransactionTests: XCTestCase {
    
    
    var creditManager: CreditManager = CreditManager.sharedInstance
    var transactionManager: TransactionManager! = TransactionManager.sharedInstance

    override func setUp() {
        super.setUp()
        self.creditManager.localBalance = 0
        TransactionManager.sharedInstance.clearCache()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTransactionCreation() {
        var transaction = Transaction(id: 1, amount: 1000, type: TransactionType.grant_locallyNo_serverLazy)
        XCTAssertEqual(transaction.status, TransactionStatus.pending_server_write, "status is server write")
        
        transaction = Transaction(id: 1, amount: 1000, type: TransactionType.grant_locallyNow_serverLazy)
        XCTAssertEqual(transaction.status, TransactionStatus.pending_server_local_write, "status is server AND local write")
    }

    // Case 1
    // Requirements: commit to server now, commit locally now
    // Condition: Both successful
    func testCaseOne() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit success")
        
        var mockedTransaction = MockedTransactionWithSucessfulServerTransaction(id: 1, amount: transactionAmount, type: .grant_locallyNow_serverNow)
        
        transactionManager.commit(mockedTransaction, handler: { (success: CommitResult) -> () in
            XCTAssertTrue(success == .Succeeded, "transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "Credit Manager should be loaded")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.commited, "status: commited")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 2
    // Requirements: commit ro server now, commit locally now
    // Condition: commit to server fails
    func testCaseTwo() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit fails")
        
        var mockedTransaction = MockedTransactionWithFailedServerTransaction(id: 1, amount: transactionAmount, type: .grant_locallyNow_serverNow)
        
        transactionManager.commit(mockedTransaction, handler: { (success: CommitResult) -> () in
            XCTAssertTrue(success == .Failed, "Transaction fails")
            XCTAssertEqual(self.creditManager.localBalance, Int32(0), "local balance should not change")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.pending_server_write, "status: pending")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 3
    // Requirements: commit to server now or later (Lazy), commit locally now
    // Condition: commit to server successful
    func testCaseThree() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit success")
        
        var mockedTransaction = MockedTransactionWithSucessfulServerTransaction(id: 1, amount: transactionAmount, type: .grant_locallyNow_serverLazy)
        
        transactionManager.commit(mockedTransaction, handler: { (success: CommitResult) -> () in
            XCTAssertTrue(success == .Succeeded, "Transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "local balance check")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.commited, "status: commited")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 4
    // Requirements: commit to server now or later (Lazy), commit locally now
    // Condition: commit to server failed
    func testCaseFour() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit fails")
        
        var mockedTransaction = MockedTransactionWithFailedServerTransaction(id: 1, amount: transactionAmount, type: .grant_locallyNow_serverLazy)
        
        transactionManager.commit(mockedTransaction, handler: { (success: CommitResult) -> () in
            XCTAssertTrue(success == .Queued, "transaction successes")
            XCTAssertEqual(self.creditManager.localBalance, transactionAmount, "local balance check")
            XCTAssertTrue(self.transactionManager.queue.includes(mockedTransaction), "should be queued")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.pending_server_write, "status: pending")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 5
    // Requirements: commit to server now or later (Lazy), dont commit locally
    // Condition: commit to server failed
    func testCaseFive() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit fails")
        
        var mockedTransaction = MockedTransactionWithFailedServerTransaction(id: 1, amount: transactionAmount, type: .grant_locallyNo_serverLazy)
        
        transactionManager.commit(mockedTransaction, handler: { (success: CommitResult) -> () in
            XCTAssertTrue(success == .Queued, "Transaction fails")
            XCTAssertEqual(self.creditManager.localBalance, Int32(0), "local credit is not affected")
            XCTAssertTrue(self.transactionManager.queue.includes(mockedTransaction), "transaction is not removed from the queue")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.pending_server_write, "status: pending")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // Case 6
    // Requirements: commit to server now or later (Lazy), dont commit locally
    // Condition: commit to server successed
    func testCaseSix() {
        var transactionAmount: Int32 = 1000
        var expectation = expectationWithDescription("BE commit successeds")
        
        var mockedTransaction = MockedTransactionWithSucessfulServerTransaction(id: 1, amount: transactionAmount, type: .grant_locallyNo_serverLazy)
        
        transactionManager.commit(mockedTransaction, handler: { (success: CommitResult) -> () in
            XCTAssertTrue(success == .Succeeded, "Transaction succeeds")
            XCTAssertEqual(self.creditManager.localBalance, Int32(0), "local credit is not affected")
            XCTAssertFalse(self.transactionManager.queue.includes(mockedTransaction), "transaction is  removed from the queue")
            XCTAssertEqual(mockedTransaction.status, TransactionStatus.commited, "status: commited")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(1, handler: { (err: NSError!) -> Void in
        })
    }
    
    // When enqueued should be also cached to disk
    func testQueueing() {
        TransactionManager.sharedInstance.clearCache()
        var transaction = Transaction(id: 1, amount: 1000, type: .grant_locallyNow_serverLazy)
        self.transactionManager.enqueue(transaction)
        var loadedTransaction = self.transactionManager.loadQueueFromDisk()![0]
        
        XCTAssertEqual(loadedTransaction.amount, transaction.amount, "the amounts are equal")
        XCTAssertEqual(loadedTransaction.id, transaction.id, "have same id")
        XCTAssertTrue(self.transactionManager.loadQueueFromDisk()!.includes(transaction), "manager holds the transaction after de-init")
    }
    
    // when get the first transaction, the id should be 1
    func testFirstTransactionID() {
        TransactionManager.sharedInstance.clearCache()
        var id = TransactionManager.sharedInstance.getNewTransactionID()
        XCTAssertEqual(id, Int64(1), "first id should be 1")
    }
    
    // when there is a transaction in the queue, the second transaction should have +1 id
    func testSecondTransaction() {
        var t1 = Transaction(id: 10, amount: 10000, type: TransactionType.grant_locallyNo_serverLazy)
        TransactionManager.sharedInstance.enqueue(t1)
        
        var id = TransactionManager.sharedInstance.getNewTransactionID()
        XCTAssertEqual(id, Int64(11), "new transaction id is one higher than max id")
    }
    
    // test sending the queued transactions
    func testQueuedTransactions() {
        var expectation = expectationWithDescription("BE commit successeds")
        var manager = TransactionManager.sharedInstance
        var t1Success = MockedTransactionWithSucessfulServerTransaction(id: 10, amount: 1000, type: .grant_locallyNow_serverLazy)
        var t2Fail = MockedTransactionWithFailedServerTransaction(id: 12, amount: 2000, type: .grant_locallyNow_serverLazy)
        manager.enqueue(t1Success)
        manager.enqueue(t2Fail)
        
        manager.sendItemsInQueue(manager.queue, completionHandler: { () -> () in
            manager.printQueue()
            XCTAssertTrue(t1Success.status == .commited, "Should be marked as commited")
            
            manager.sendItemsInQueue(manager.queue, completionHandler: { () -> () in
                manager.printQueue()
                XCTAssertFalse(manager.queue.includes(t1Success), "Should not exist in the queue next time")
                expectation.fulfill()
            })
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
