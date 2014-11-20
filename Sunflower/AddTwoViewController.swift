//
//  AddTwoViewController.swift
//  Sunflower
//
//  Created by Arash K. on 19/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class AddTwoViewController: UIViewController {
    var tokens: [String]!
    var corpus: String!
    var sourceLanguage: String!
    var alertViewShown: Bool = false
    
    var selectedTokens: [String]!

    @IBOutlet weak var labelBalance: UILabel!
    @IBOutlet weak var labelCost: UILabel!
    @IBOutlet weak var labelTotalTokens: UILabel!
    @IBOutlet weak var labelSelectedTokens: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedTokens = self.tokens
    }
    
    func updateBalanceLabel() {
        self.labelBalance.text = "Balance: \(CreditManager.sharedInstance.localBalance)"
    }
    
    func updateCostLabel() {
        self.labelCost.text = "Cost for selected tokens: \(GoogleTranslate.sharedInstance.costToTranslate(self.selectedTokens))"
    }
    
    func updateTotalTokensLabel() {
        self.labelTotalTokens.text = "Total tokens: \(self.tokens.count)"
    }
    
    func updateSelectedTokensLabel() {
        self.labelSelectedTokens.text = "Selected tokens: \(self.selectedTokens.count)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onNextTapped(sender: AnyObject) {
        if userHasEnoughCredit()
        {
            self.performSegueWithIdentifier("fromaddtwotoaddthree", sender: nil)
        } else {
            self.performSegueWithIdentifier("fromaddtwotobuycredit", sender: nil)
        }
    }
    
    func userHasEnoughCredit() -> Bool{
        return true
    }
    
    func showErrorAlertWithMesssage(message: String) {
        if alertViewShown { return }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK!", style: .Cancel) { (action) in
            self.alertViewShown = false
        }
        
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
            self.alertViewShown = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
