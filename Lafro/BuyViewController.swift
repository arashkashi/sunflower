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

    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var buttonBuy: UIButton!
    
    @IBAction func onBuyTapped(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PaymentManager.sharedInstance.requestProductsFor(NSSet(array: ["sunflower.dollar.1"]), delegate: self)
        labelTitle.text = "Loading Products..."
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: product Request Delegate
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var skProducts = response.products
        
        for product in skProducts {
            labelTitle.text = "Spend \(product.price) to buy credit for translating \(product.localizedTitle)"
        }
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
