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
        var request = SKProductsRequest(productIdentifiers: productIdentifiers as Set<NSObject>)
        
        if delegate != nil {
            request.delegate = delegate
        } else {
            request.delegate = self
        }
        request.start()
    }
    
    func payForProduct(product: SKProduct) {
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NOTIF_TRANSACTIONS_UPDATED, object: self, userInfo: [ NOTIF_USER_INFO_UPDATED_TRANSACTIONS:transactions]))
    }
    
    func finishTransaction(paymentTransaction: SKPaymentTransaction) {
        SKPaymentQueue.defaultQueue().finishTransaction(paymentTransaction)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: NOTIF_IN_APP_PURCHASE_TRANSACTION_UPDATED, object: paymentTransaction))
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
