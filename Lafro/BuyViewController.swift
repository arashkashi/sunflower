//
//  BuyViewController.swift
//  Lafro
//
//  Created by Arash K. on 26/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {

    @IBOutlet var labelBalance: UILabel!
    @IBOutlet var buttonBuy: UIButton!
    
    @IBAction func onBuyTapped(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var balance = CreditManager.sharedInstance.localBalance
//        labelBalance.text = "Balance: \(balance)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
