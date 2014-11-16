//
//  TransactionManager.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class TransactionManager {
    
    var queue: [Transaction] = []
    
    func enqueue(transation: Transaction) {
        self.queue.append(transation)
    }
    
    func emptyQueu() {
        
    }
    
    init () {
        if queue.count > 0 {
            self.emptyQueu()
        }
    }
    
    // MARK: Initiation
    class var sharedInstance : TransactionManager {
        struct Static {
            static let instance : TransactionManager = TransactionManager()
        }
        return Static.instance
    }
    
}
