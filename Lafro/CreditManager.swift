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
    
    var isInitialFreeCreditGranted: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(kCreditManagerInitialCreditGranted) != nil
        }
        
        set {
            if newValue == true {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kCreditManagerInitialCreditGranted)
            }
        }
    }
    
    var isInitialServerSyncDoned: Bool {
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
    
    func chargeCreditWithProduct(product: SKProduct) {
        PaymentManager.sharedInstance.payForProduct(product)
    }
    
    // MARK: Server Calls
    func resetInitialCreditGranted(handler: ()->()) {
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            record!.setObject(nil, forKey: kCreditManagerInitialCreditGranted)
            record!.setObject(nil, forKey: kCreditManagerBalance)
            CloudKitManager.sharedInstance.saveRecord(record!, handler: { (newRecord: CKRecord!, lastError: NSError!) -> Void in
                if newRecord != nil && lastError == nil {
                    NSLog("\(__FILE__):\(__LINE__) \t\t --> Reset the initial credit grant on server");
                }
                handler()
                }
                
            )}
    }
    
    func grantInitialCreditToServer(initialCredit: Lafru, handler: (Bool, NSError?)->() ) {
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            
            if record == nil || err != nil {
                handler(false, err); return
            }
            
            // Case: Initial credit is granted
            if record!.allKeys().includes(kCreditManagerInitialCreditGranted) {
                handler(true, nil)
                return
            }
            else
            {
                // Case: Initial credit is not granted
                record!.setObject(true, forKey: kCreditManagerInitialCreditGranted)
                
                var totalBalance: Int = 0
                
                if let currentServerBalance = record!.objectForKey(kCreditManagerBalance) as? NSNumber {
                    totalBalance = Int(initialCredit + currentServerBalance.intValue)
                } else {
                    totalBalance = Int(initialCredit)
                }
                
                record!.setObject(totalBalance, forKey: kCreditManagerBalance)
                
                CloudKitManager.sharedInstance.saveRecord(record!, handler: { (newRecord: CKRecord!, lastError: NSError!) -> Void in
                    if lastError == nil && newRecord != nil
                    {
                        self.localBalance = Int32(totalBalance)
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
    
    func processInitialSyncServer() {
        if self.isInitialServerSyncDoned {
            return
        }
        
        CloudKitManager.sharedInstance.fetchUserRecord { (record, err) -> () in
            if record != nil {
                if let currentServerBalance = record!.objectForKey(kCreditManagerBalance) as? NSNumber {
                    self.localBalance = currentServerBalance.intValue
                }
                self.isInitialServerSyncDoned = true
            }
        }
    }
    
    // MARK: Events
    func onAppleTransactionsUpdated(notification: NSNotification) {
        var updatedAppleTransactions = notification.userInfo?[NOTIF_USER_INFO_UPDATED_TRANSACTIONS] as? [SKPaymentTransaction]
        
        if let appleTransactions = updatedAppleTransactions{
            for appleTransaction in appleTransactions {
                println("\(appleTransaction.error)")
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
        appDelegate.showInformationWithMessage("Payment Failed", message: "\(appleTransaction.error.userInfo?.description)")
        
        
        // Finish the transaction
        PaymentManager.sharedInstance.finishTransaction(appleTransaction)
    }
    
    func onAppleTransactionPurchased(appleTransaction: SKPaymentTransaction) {
        
        var amount = lafroFromProductID(appleTransaction.payment.productIdentifier)
        
        var lafroTransaction = TransactionManager.sharedInstance.getNewTransaction(amount, type: .grant_locallyNow_serverLazy)
        
        // Exceptionaly put this here inspite of Apple recommandation to close transaction when
        // truely finished with all tasks. Yes we are not finished with the commit but since
        // the next step (commit transaction local now and lazy server) is risk free, then there 
        // should be no problem.
        PaymentManager.sharedInstance.finishTransaction(appleTransaction)
        
        var tracker = GAI.sharedInstance().defaultTracker
        var id = NSDate().toString("yyyy-MM-dd HH:mm:ss.SSS")
        tracker.send(["IAP":1, id: id])
        
        TransactionManager.sharedInstance.commit(lafroTransaction, handler: { (result: CommitResult) -> () in
            if result == .Queued || result == .Succeeded {
                
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
            return CreditManager.sharedInstance.initialBalance
        } else {
            return 0
        }
    }
    
    func hasCreditFor(amount: Lafru) -> Bool {
        return amount < localBalance
    }
    
    func initNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIF_TRANSACTIONS_UPDATED, object: nil, queue: nil) { (note: NSNotification!) -> Void in
            self.onAppleTransactionsUpdated(note)
        }
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
        
        if !isInitialFreeCreditGranted {
            grantInitialCreditToServer(self.initialBalance , handler: { (success: Bool, err: NSError?) -> () in
                if success {
                    self.isInitialFreeCreditGranted = true
                }
            })
        }
        
        if !isInitialServerSyncDoned {
            processInitialSyncServer()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
