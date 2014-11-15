//
//  Transaction.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kTransactionAmount = "kTransactionAmount"
let kTransactionType = "kTransactionType"

import Foundation

class Transaction:  NSCoding {
    
    var amount: Int32
    var manager: TransactionManager
    
    func commit(type: TransactionType, handler: ((Bool)->())) {
        
        // Grant locally
        if type.shouldGrantLocally()
        {
            CreditManager.sharedInstance.commitLocalTransaction(self)
        }
        
        // Grant Backend
        if type.shouldGrantServer() {
            self.commitBETransation { (success: Bool) -> () in
                if success {
                    handler(true); return
                } else {
                    if type.shouldGrantServer() && type.shouldGrantLocally() {
                        CreditManager.sharedInstance.undoLocalTransaction(self)
                        handler(false); return
                    }
                    
                    if type.shouldGrantServer() {
                        CreditManager.sharedInstance.undoLocalTransaction(self)
                        handler(false); return
                    }
                }
            }
        }
    }
    
    func commitBETransation(transaction: Transaction, beHandler: ((Bool)->()) ) {
        var success = true
        
        if success { beHandler(true) }
    }
    
    // MARK: Initiation
    init(amount: Int32) {
        self.amount = amount
        self.manager = TransactionManager.sharedInstance
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.amount = aDecoder.decodeInt32ForKey(kTransactionAmount)
        self.manager = TransactionManager.sharedInstance
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(self.amount, forKey: kTransactionAmount)
    }
    

}
