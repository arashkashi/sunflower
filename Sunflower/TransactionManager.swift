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
    
    func sendItemsInQueue(queue: [Transaction]) {
        
    }
    
    // MARK: Initiation
    class var sharedInstance : TransactionManager {
        struct Static {
            static let instance : TransactionManager = TransactionManager()
        }
        return Static.instance
    }
    
    init () {
        queue = []
        
        if let cachedQueue = loadQueueFromDisk() { queue = cachedQueue } else { queue = [] }
        
        if queue.count > 0 { sendItemsInQueue(queue) }
    }
    
    // MARK: Caching
    func saveQueueToDisk() {
        var data = NSKeyedArchiver.archivedDataWithRootObject(self.queue)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: kTransactionManagercachedQueue)
    }
    
    func loadQueueFromDisk() -> [Transaction]? {
        var dataOptional: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(kTransactionManagercachedQueue)
        if let data = dataOptional as? NSData {
            var queue: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data as NSData)
            if let transactions = queue as? [Transaction] {
                return transactions
            }
        }

        return nil
    }
    
}
