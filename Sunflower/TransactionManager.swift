//
//  TransactionManager.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kTransactionManagercachedQueue = "kTransactionManagercachedQueue"

import Foundation

class TransactionManager {
    
    var queue: [Transaction]
    
    func enqueue(transaction: Transaction) {
        if !queue.includes(transaction) { queue.append(transaction) }
        saveQueueToDisk()
    }
    
    func sendItemsInQueue(queue: [Transaction], completionHandler: (()->())?) {
        var counter = 0
        var localQueue = queue
        for transaction in localQueue {
//            transaction.commit({ (success: Bool) -> () in
//                counter++
//                if counter == localQueue.count {
//                    self.cleanQueueFromCommitedTransactions()
//                    completionHandler?()
//                }
//            })
        }
    }
    
    func cleanQueueFromCommitedTransactions() {
        queue = queue.filter{ $0.status ==  TransactionStatus.commited}
        saveQueueToDisk()
    }
    
    // MARK: Initiation
    class var sharedInstance : TransactionManager {
        struct Static {
            static let instance : TransactionManager = TransactionManager()
        }
        return Static.instance
    }
    
    func getNewTransaction(amount: Lafru, type: TransactionType) -> Transaction {
        var id = getNewTransactionID()
        return Transaction(id: id, amount: amount, type: type)
    }
    
    func getNewTransactionID() -> Int64 {
        var idsInQueue: [Int64] = queue.map{$0.id}
        printqueue()
        var maxExistingId = idsInQueue.reduce(Int64(0), { max($0, $1) })
        return maxExistingId + 1
    }
    
    init () {
        queue = []
        
        if let cachedQueue = loadQueueFromDisk() { queue = cachedQueue } else { queue = [] }
        
        if queue.count > 0 { sendItemsInQueue(queue, completionHandler: nil) }
    }
    
    func printqueue() {
        for item in queue {
            println("id: \(item.id), amount: \(item.amount)")
        }
    }
    
    // MARK: Caching
    func saveQueueToDisk() {
        var data = NSKeyedArchiver.archivedDataWithRootObject(self.queue)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: kTransactionManagercachedQueue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadQueueFromDisk() -> [Transaction]? {
        var dataOptional: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(kTransactionManagercachedQueue)
        if let data = dataOptional as? NSData {
            var queue: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            if let transactions = queue as? [Transaction] {
                return transactions
            }
        }
        return nil
    }
    
    
    func clearCache() {
        var dummy : [Transaction] = []
        NSUserDefaults.standardUserDefaults().setObject(dummy, forKey: kTransactionManagercachedQueue)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.queue = dummy
    }
    
}
