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
    
    
    class var sharedInstance : PaymentManager {
        struct Static {
            static let instance : PaymentManager = PaymentManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
//        self.requestProductsFor(NSSet(array: ["www.sunflower.com.lafro2000laf"]))
    }
    
    func requestProductsFor(productIdentifiers: NSSet) {
        var request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    
    // MARK: product Request Delegate
    func productsRequest(request: SKProductsRequest!,
        didReceiveResponse response: SKProductsResponse!) {
        var skProducts = response.products
            
            for invalidProducts in response.invalidProductIdentifiers {
                NSLog("\(invalidProducts)")
            }
        
        for product in skProducts {
            NSLog("\(product.productIdentifier)+ \(product.localizedTitle) + \(product.price)")
        }
    }
   
}
