//
//  TransactionManager.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

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
    class func transactionManagerFileURL() -> NSURL {
        var filename = "transactionManager.archive"
        var url: NSURL? = DiskCache.libraryDirectoryURL()?.URLByAppendingPathComponent(filename)
        return url!
    }
    
    func saveQueueToDisk() {
        DiskCache.saveObjectToURL(self.queue, url: TransactionManager.transactionManagerFileURL())
    }
    
    func loadQueueFromDisk() -> [Transaction]? {
        return DiskCache.loadObjectFromURL(TransactionManager.transactionManagerFileURL()) as? [Transaction]
    }
    
}
