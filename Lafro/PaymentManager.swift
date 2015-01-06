//
//  PaymentManager.swift
//  Lafro
//
//  Created by ArashHome on 26/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import StoreKit

class PaymentManager: NSObject,  SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    let productIDs = ["sunflower.dollar.1"]
    
    
    class var sharedInstance : PaymentManager {
        struct Static {
            static let instance : PaymentManager = PaymentManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
//        requestProductsFor(NSSet(array: ["sunflower.dollar.1"]))
    }
    
    func requestProductsFor(productIdentifiers: NSSet, delegate: SKProductsRequestDelegate?) {
        var request = SKProductsRequest(productIdentifiers: productIdentifiers)
        
        if delegate != nil {
            request.delegate = delegate
        } else {
            request.delegate = self
        }
        request.start()
    }
    
    func buyProduct(product: SKProduct) {
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
        
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState
            {
            case .Purchasing:   // Transaction is being added to the server queue.
                break
            case .Purchased:    // Transaction is in queue, user has been charged.  Client should complete the transaction.
                //[self completeTransaction:transaction];
                break
            case .Failed:       // Transaction was cancelled or failed before being added to the server queue.
                //[self failedTransaction:transaction];
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
    
    func completeTransaction(payment: SKPaymentTransaction) {
        var transaction = TransactionManager.sharedInstance.getNewTransaction(2000, type: .grant_locallyNow_serverNow)
        TransactionManager.sharedInstance.commit(transaction, handler: { (result: CommitResult) -> () in
            switch result {
            case .Succeeded:
                
            }
        })
        
    }
    
    func failTransaction(payment: SKPaymentTransaction) {
        
    }
    
    // MARK: product Request Delegate
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var skProducts = response.products
        
        for invalidProducts in response.invalidProductIdentifiers {
            NSLog("\(invalidProducts)")
        }
        
        for product in skProducts {
            NSLog("\(product.productIdentifier)+ \(product.localizedTitle) + \(product.price)")
        }
    }
}
