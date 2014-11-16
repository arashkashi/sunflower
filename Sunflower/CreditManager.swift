//
//  CreditManager.swift
//  Sunflower
//
//  Created by Arash K. on 08/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kCreditManagerBalance = "kCreditManagerBalance"

let KCreditManagerErrCodeCreditAlreadyGranted = 96


typealias Lafru = Int32
typealias Dollar = Double

import Foundation
import CloudKit

class CreditManager {
    
    var localBalance: Lafru {
        get {
            var intVar = NSUserDefaults.standardUserDefaults().integerForKey(kCreditManagerBalance)
            return Int32(intVar);
        }
        
        set {
            var castedNewValue = Int(newValue)
            NSUserDefaults.standardUserDefaults().setInteger(castedNewValue, forKey: kCreditManagerBalance)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    let initialBalance: Lafru = 5000
    let costPerCharacter = 0.0002
    
    func commitLocalTransaction(transaction: Transaction) {
        localBalance = localBalance + transaction.amount
    }
    
    func undoLocalTransaction(transaction: Transaction) {
        localBalance = localBalance - transaction.amount
    }
    
    func hasCreditFor(amount: Lafru) -> Bool {
        return amount < localBalance
    }
    
    // MARK: Server Calls
    func askServerIfInitialCreditGranted( handler: (Bool, CKRecord?)->() ) {
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            if record == nil || err != nil { handler(false, nil) }
            if record!.allKeys().includes(kCreditManagerBalance)
            { handler(true, record!) } else {
                handler(false, record!)
            }
        }
    }

    func grantInitialCreditToServer(initialCredit: Lafru, handler: (Bool, NSError?)->() ) {
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            
            if record == nil || err != nil {
                handler(false, err); return
            }
            
            if record!.allKeys().includes(kCreditManagerBalance) {
                handler(false, NSError(domain: "CreditManager", code: KCreditManagerErrCodeCreditAlreadyGranted, userInfo: nil))
                return
            } else {
                record!.setObject(Int(initialCredit), forKey: kCreditManagerBalance)
                
                CloudKitManager.sharedInstance.saveRecord(record!, handler: { (newRecord: CKRecord!, lastError: NSError!) -> Void in
                    if lastError == nil { handler(true, nil); return }
                    else { handler(false, lastError); return }
                })
            }
        }
    }

    
    //  MARK: Helper
    func lafruToDollar(amount: Lafru) -> Dollar {
        return  Double(amount) * self.costPerCharacter
    }
    
    func dollarToLafru(dollar: Dollar) -> Lafru {
        return (Lafru)(Double(dollar) / self.costPerCharacter)
    }
    
    // MARK: Initiation
    class var sharedInstance : CreditManager {
        struct Static {
            static let instance : CreditManager = CreditManager()
        }
        return Static.instance
    }
    
    init() {
        self.grantInitialCreditToServer(self.initialBalance , handler: { (success: Bool, err: NSError?) -> () in
            if success && err == nil { self.localBalance = self.initialBalance }
        })
    }
}
