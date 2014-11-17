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
import CloudKit

class Transaction:  NSCoding, Equatable {
    
    var amount: Int32
    var type: TransactionType
    var status: TransactionStatus
    var manager: TransactionManager
    var createDate: NSDate
    
    func commit(handler: ((Bool)->())) {
        // Grant locally
        if type.shouldGrantLocallyNow() {
            self.commitLocalTransaction()
            self.status.onSuccessfulLocalWrite()
        }
        
        // Grant Backend
        if type.shouldGrantServerLazy() || type.shouldGrantLocallyNow() {
            self.commitServerTransation { (success: Bool) -> () in
                if success {
                    self.status.onSuccessfulServerWrite()
                    handler(true); return
                } else {
                    
                    // Should've written to server now, FAIL
                    if self.type.shouldGrantServerNow() {
                        self.undoLocalTransaction()
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
    
    func commitLocalTransaction() {
        CreditManager.sharedInstance.commitLocalTransaction(self)
    }
    
    func undoLocalTransaction() {
        CreditManager.sharedInstance.undoLocalTransaction(self)
    }
    
    func commitServerTransation( beHandler: ((Bool)->()) ) {
        
        // Get user record
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            if record == nil || err != nil { beHandler(false); return }
            
            var newBalance: Int32 = 0
            if let currentBalance = record!.objectForKey(kCreditManagerBalance) as? NSNumber {
                newBalance = currentBalance.intValue + self.amount
            } else {
                newBalance = self.amount
            }
            
            record!.setObject(NSNumber(int: newBalance), forKey: kCreditManagerBalance)
            
            CloudKitManager.sharedInstance.saveRecord(record!, handler: { (updatedRecord: CKRecord!, updatingError: NSError!) -> Void in
                if updatedRecord == nil || updatingError != nil {
                    beHandler(false)
                } else {
                    beHandler(true)
                }
            })
        }
        
        // If initial credit is granted add it to transaction
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
