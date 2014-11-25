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
let KTransactionID = "KTransactionID"

import Foundation
import CloudKit

func == (lhs: Transaction, rhs: Transaction) -> Bool {
    return lhs.id == rhs.id
}

class Transaction: NSObject, NSCoding, Equatable {
    
    var amount: Int32
    var type: TransactionType
    var status: TransactionStatus
    var createDate: NSDate
    var id: Int64
    
    func commit( handler: ((CommitResult)->())?) {
        // Grant locally
        if type.shouldGrantLocallyNow() {
            self.commitLocal()
            self.status.onSuccessfulLocalWrite()
        }
        
        // Grant Backend
        if type.shouldGrantServerLazy() || type.shouldGrantLocallyNow() {
            self.commitServerTransation { (success: Bool) -> () in
                if success {
                    self.status.onSuccessfulServerWrite()
                    handler?(CommitResult.Succeeded); return
                } else {
                    
                    // Should've written to server now, FAIL
                    if self.type.shouldGrantServerNow() {
                        self.undoLocalCommit()
                        handler?(.Failed); return
                    }
                    
                    if self.type.shouldGrantServerLazy() {
                        // Should've written only to server, FAIL
                        if self.type == .grant_locallyNo_serverLazy {
                            handler?(.Queued); return
                        }
                        else //Save locally and can write Server later, Success
                        {
                            self.type = .grant_locallyNo_serverLazy
                            handler?(.Queued); return
                        }
                    }
                    handler?(.Failed); return
                }
            }
        }
    }
    
    func commitLocal() {
        CreditManager.sharedInstance.commitLocalTransaction(self)
    }
    
    func undoLocalCommit() {
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
    }
    
    // MARK: Initiation
    init(id: Int64, amount: Int32, type: TransactionType) {
        self.amount = amount
        self.type = type
        self.status = TransactionStatus.initialStatus(type)
        self.createDate = NSDate()
        self.id = id
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        self.amount = aDecoder.decodeInt32ForKey(kTransactionAmount)
        self.type = TransactionType.initWithInt(aDecoder.decodeInt32ForKey(kTransactionType))
        self.createDate = aDecoder.decodeObjectForKey(kTransactionCreationDate) as NSDate
        self.status = TransactionStatus.initWithInt(aDecoder.decodeInt32ForKey(kTransactionStatus))
        self.id = aDecoder.decodeInt64ForKey(KTransactionID)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(self.amount, forKey: kTransactionAmount)
        aCoder.encodeInt32(self.type.toInt32(), forKey: kTransactionType)
        aCoder.encodeObject(self.createDate, forKey: kTransactionCreationDate)
        aCoder.encodeInt32(self.status.toInt32(), forKey: kTransactionStatus)
        aCoder.encodeInt64(self.id, forKey: KTransactionID)
    }
    

}
