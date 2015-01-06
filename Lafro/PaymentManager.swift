//
//  PaymentManager.swift
//  Lafro
//
//  Created by ArashHome on 26/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import StoreKit

class PaymentManager: NSObject,  SKProductsRequestDelegate  {
    
    let productIDs = ["sunflower.dollar.1"]
    
    
    class var sharedInstance : PaymentManager {
        struct Static {
            static let instance : PaymentManager = PaymentManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
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
