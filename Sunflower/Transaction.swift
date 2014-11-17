//
//  Transaction.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kTransactionAmount = "kTransactionAmount"
let kTransactionType = "kTransactionType"
let kTransactionCreationDate = "kTransactionCreationDate"
let kTransactionStatus = "kTransactionStatus"

import Foundation

class Transaction:  NSCoding, Equatable {
    
    var amount: Int32
    var type: TransactionType
    var status: TransactionStatus
    var manager: TransactionManager
    var createDate: NSDate
    
    func commit(handler: ((Bool)->())) {
        // Grant locally
        if type.shouldGrantLocallyNow() {
            CreditManager.sharedInstance.commitLocalTransaction(self)
            self.status.onSuccessfulLocalWrite()
        }
        
        // Grant Backend
        if type.shouldGrantServerLazy() || type.shouldGrantLocallyNow() {
            self.commitBETransation { (success: Bool) -> () in
                if success {
                    self.status.onSuccessfulServerWrite()
                    handler(true); return
                } else {
                    
                    // Should've written to server now, FAIL
                    if self.type.shouldGrantServerNow() {
                        CreditManager.sharedInstance.undoLocalTransaction(self)
                        handler(false); return
                    }
                    
                    if self.type.shouldGrantServerLazy() {
                        TransactionManager.sharedInstance.enqueue(self)
                        // Should've written only to server, FAIL
                        if self.type == .grant_locallyNo_serverLazy {
                            handler(false); return
                        }
                        else //Save locally and can write Server later, Success
                        {
                            self.type = .grant_locallyNo_serverLazy
                            handler(true); return
                        }
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
        self.status = TransactionStatus.initialStatus(type)
        self.createDate = NSDate()
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.amount = aDecoder.decodeInt32ForKey(kTransactionAmount)
        self.type = TransactionType.initWithInt(aDecoder.decodeInt32ForKey(kTransactionType))
        self.createDate = aDecoder.decodeObjectForKey(kTransactionCreationDate) as NSDate
        self.status = TransactionStatus.initWithInt(aDecoder.decodeInt32ForKey(kTransactionStatus))
        self.manager = TransactionManager.sharedInstance
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(self.amount, forKey: kTransactionAmount)
        aCoder.encodeInt32(self.type.toInt32(), forKey: kTransactionType)
        aCoder.encodeObject(self.createDate, forKey: kTransactionCreationDate)
        aCoder.encodeInt32(self.status.toInt32(), forKey: kTransactionStatus)
    }
    

}
