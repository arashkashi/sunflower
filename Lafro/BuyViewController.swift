//
//  BuyViewController.swift
//  Lafro
//
//  Created by Arash K. on 26/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import StoreKit

class BuyViewController: UIViewController, SKProductsRequestDelegate {
    
    var requestedProducts: [SKProduct]?

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var buttonBuy: UIButton!
    
    @IBAction func onBuyTapped(sender: AnyObject) {
        if requestedProducts?.count > 0 {
            var product = requestedProducts![0]
            CreditManager.sharedInstance.chargeCreditWithProduct(product)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PaymentManager.sharedInstance.requestProductsFor(NSSet(array: ["sunflower.dollar.1"]), delegate: self)
        labelTitle.text = "Loading Products..."
        buttonBuy.hidden = true
        onRequestingProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: product Request Delegate
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var skProducts = response.products as? [SKProduct]
        
        if let products = skProducts {
            onReceivingProducts(products)
        }
    }
    
    // MARK: Events 
    func onRequestingProducts() {
        
    }
    
    func onReceivingProducts(products: [SKProduct]) {
        for product in products {
//            labelTitle.text = "Spend \(product.price) to buy credit for translating \(product.localizedTitle)"
            labelTitle.text = "Donate \(product.price) to support lafro"
        }
        
        buttonBuy.hidden = false
        
        requestedProducts = products
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
