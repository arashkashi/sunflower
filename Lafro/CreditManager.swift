//
//  CreditManager.swift
//  Sunflower
//
//  Created by Arash K. on 08/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kCreditManagerBalance = "kCreditManagerBalance"
let kCreditManagerInitialCreditGranted = "kCreditManagerInitialCreditGranted"
let kCreditManagerInitialServerSync = "kCreditManagerInitialServerSync"

let KCreditManagerErrCodeCreditAlreadyGranted = 96



typealias Lafru = Int32
typealias Dollar = Double

import Foundation
import CloudKit
import StoreKit

class CreditManager {
    
    var isInitialServerSyncDone: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kCreditManagerInitialServerSync) != nil
        }
        
        set {
            if newValue == true {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kCreditManagerInitialServerSync)
            }
        }
    }
    
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
    
    let initialBalance: Lafru = 2000
    let costPerCharacter = 0.0005  // Google translate cost of character is 0,00002 Dollars
    
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
    func resetInitialCreditGranted() {
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            record!.setObject(nil, forKey: kCreditManagerInitialCreditGranted)
            record!.setObject(nil, forKey: kCreditManagerBalance)
            CloudKitManager.sharedInstance.saveRecord(record!, handler: { (newRecord: CKRecord!, lastError: NSError!) -> Void in
                if newRecord != nil && lastError == nil {
                    NSLog("\(__FILE__):\(__LINE__) \t\t --> Reset the initial credit grant on server");
                }
                
                }
            )}
    }
    
    func grantInitialCreditToServer(initialCredit: Lafru, handler: (Bool, NSError?)->() ) {
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            
            if record == nil || err != nil {
                NSLog("\(__FILE__):\(__LINE__) \t\t --> Failed to fetch user record");
                handler(false, err); return
            }
            
            if record!.allKeys().includes(kCreditManagerInitialCreditGranted) {
                if !self.isInitialServerSyncDone {
                    if let currentServerBalance = record!.objectForKey(kCreditManagerBalance) as? NSNumber {
                        self.localBalance = currentServerBalance.intValue
                        self.isInitialServerSyncDone = true
                        NSLog("\(__FILE__):\(__LINE__) \t\t --> Local balance synced with Server");
                    } else {
                        NSLog("\(__FILE__):\(__LINE__) \t\t --> Local balance NOT synced with server");
                    }
                }
                
                handler(true, nil)
                return
            } else {
                record!.setObject(true, forKey: kCreditManagerInitialCreditGranted)
                
                if let currentServerBalance = record!.objectForKey(kCreditManagerBalance) as? NSNumber {
                    record!.setObject(Int(initialCredit + currentServerBalance.intValue), forKey: kCreditManagerBalance)
                } else {
                    record!.setObject(Int(initialCredit), forKey: kCreditManagerBalance)
                }
                
                CloudKitManager.sharedInstance.saveRecord(record!, handler: { (newRecord: CKRecord!, lastError: NSError!) -> Void in
                    if lastError == nil && newRecord != nil
                    {
                        self.localBalance = initialCredit
                        self.isInitialServerSyncDone = true
                        NSLog("\(__FILE__):\(__LINE__) \t\t --> Successfully granted initial credit to server");
                        handler(true, nil); return
                    }
                    else
                    {
                        NSLog("\(__FILE__):\(__LINE__) \t\t --> Failed to grant initial credit to server");
                        handler(false, lastError); return
                    }
                })
            }
        }
    }
    
    // MARK: Events
    func onTransactionsUpdated(notification: NSNotification) {
        var updatedAppleTransactions = notification.userInfo?[USER_INFO_UPDATED_TRANSACTIONS] as? [SKPaymentTransaction]
        
        if let appleTransactions = updatedAppleTransactions{
            for appleTransaction in appleTransactions {
                switch appleTransaction.transactionState
                {
                case .Purchasing:   // Transaction is being added to the server queue.
                    break
                case .Purchased:    // Transaction is in queue, user has been charged.  Client should complete the transaction.
                    onAppleTransactionPurchased(appleTransaction)
                    break
                case .Failed:       // Transaction was cancelled or failed before being added to the server queue.
                    onAppleTransactionFailed(appleTransaction)
                    break
                case .Restored:     // Transaction was restored from user's purchase history.  Client should complete the transaction.
                    break
                case .Deferred:     // The transaction is in the queue, but its final status is pending external action.
                    break
                default:
                    break
                }
            }
        }
    }
    
    func onAppleTransactionFailed(appleTransaction: SKPaymentTransaction) {
        
        // Show a alert view that transaction has failed
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.showInformationWithMessage("Error", message: "Apple Payment Failed")

        
        // Finish the transaction
        PaymentManager.sharedInstance.finishTransaction(appleTransaction)
    }
    
    func onAppleTransactionPurchased(appleTransaction: SKPaymentTransaction) {
        
        var amount = lafroFromProductID(appleTransaction.payment.productIdentifier)
        
        var lafroTransaction = TransactionManager.sharedInstance.getNewTransaction(amount, type: .grant_locallyNow_serverLazy)
        
        TransactionManager.sharedInstance.commit(lafroTransaction, handler: { (result: CommitResult) -> () in
            if result == .Queued || result == .Succeeded {
                PaymentManager.sharedInstance.finishTransaction(appleTransaction)
            } else {
                assert(false, "code path should never come here")
            }
        })
    }
    
    //  MARK: Helper
    func lafruToDollar(amount: Lafru) -> Dollar {
        return  Double(amount) * self.costPerCharacter
    }
    
    func dollarToLafru(dollar: Dollar) -> Lafru {
        return (Lafru)(Double(dollar) / self.costPerCharacter)
    }
    
    func lafroFromProductID(productID: String) -> Lafru {
        if productID == "sunflower.dollar.1" {
            return 2000
        } else {
            return 0
        }
    }
    
    func initNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onTransactionsUpdated:"), name: NOTIFICATION_TRANSACTIONS_UPDATED, object: nil)
    }
    
    // MARK: Initiation
    class var sharedInstance : CreditManager {
        struct Static {
            static let instance : CreditManager = CreditManager()
        }
        return Static.instance
    }
    
    init() {
        initNotifications()
        self.grantInitialCreditToServer(self.initialBalance , handler: { (success: Bool, err: NSError?) -> () in
        
        })
    }
}
