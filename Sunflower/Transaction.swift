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
    var type: TransactionType
    var manager: TransactionManager
    
    func commit(handler: ((Bool)->())) {
        
        // Grant locally
        if type.shouldGrantLocallyNow() {
            CreditManager.sharedInstance.commitLocalTransaction(self)
        }
        
        // Grant Backend
        if type.shouldGrantServerNowOrLater() {
            self.commitBETransation { (success: Bool) -> () in
                if success {
                    handler(true); return
                } else {
                    if self.type.shouldGrantLocallyNow() {
                        CreditManager.sharedInstance.undoLocalTransaction(self)
                    }
                    handler(false); return
                }
            }
        }
    }
    
    func commitBETransation( beHandler: ((Bool)->()) ) {
        var success = true
        
        if success { beHandler(true) }
    }
    
    // MARK: Initiation
    init(amount: Int32, type: TransactionType) {
        self.amount = amount
        self.manager = TransactionManager.sharedInstance
        self.type = type
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.amount = aDecoder.decodeInt32ForKey(kTransactionAmount)
        self.type = TransactionType.initWithInt(aDecoder.decodeInt32ForKey(kTransactionType))
        self.manager = TransactionManager.sharedInstance
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(self.amount, forKey: kTransactionAmount)
        aCoder.encodeInt32(self.type.toInt32(), forKey: kTransactionType)
    }
    

}
