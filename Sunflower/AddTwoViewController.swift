//
//  AddTwoViewController.swift
//  Sunflower
//
//  Created by Arash K. on 19/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class AddTwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var tokens: [String]!
    var corpus: String!
    var sourceLanguage: String!
    var alertViewShown: Bool = false
    
    var selectedTokens: [String]!
    var deselectedtokens: [String]!

    @IBOutlet weak var labelBalance: UILabel!
    @IBOutlet weak var labelCost: UILabel!
    @IBOutlet weak var labelTotalTokens: UILabel!
    @IBOutlet weak var labelSelectedTokens: UILabel!
    
    // MARK : override uiviewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedTokens = self.tokens
        self.deselectedtokens = []
        
        updateTopTexts()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: MAinulate/update the view
    func updateBalanceLabel() {
        self.labelBalance.text = "Balance: \(CreditManager.sharedInstance.localBalance)"
    }
    
    func updateCostLabel() {
        self.labelCost.text = "Cost: \(GoogleTranslate.sharedInstance.costToTranslate(self.selectedTokens))"
    }
    
    func updateTotalTokensLabel() {
        self.labelTotalTokens.text = "Total tokens: \(self.tokens.count)"
    }
    
    func updateSelectedTokensLabel() {
        self.labelSelectedTokens.text = "Selected tokens: \(self.selectedTokens.count)"
    }
    
    func updateTopTexts() {
        updateBalanceLabel()
        updateCostLabel()
        updateTotalTokensLabel()
        updateSelectedTokensLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: IBAction
    @IBAction func onNextTapped(sender: AnyObject) {
        if userHasEnoughCredit()
        {
            self.performSegueWithIdentifier("fromaddtwotoaddthree", sender: nil)
        } else {
            self.performSegueWithIdentifier("fromaddtwotobuycredit", sender: nil)
        }
    }
    
    // MARK: Logic
    func userHasEnoughCredit() -> Bool{
        return true
    }
    
    func isTokenSelected(token: String) -> Bool {
        return self.selectedTokens.includes(token)
    }
    
    func isTokenDesecleted(token: String) -> Bool {
        return self.deselectedtokens.includes(token)
    }
    
    func selectToken(token: String) {
        assert(!selectedTokens.includes(token), "already selected")
        assert(deselectedtokens.includes(token), "should be currently deselected")
        
        selectedTokens.append(token)
        deselectedtokens = deselectedtokens.filter {$0 != token}
    }
    
    func deselectToken(token: String) {
        assert(!deselectedtokens.includes(token), "already deselected")
        assert(selectedTokens.includes(token), "should be currently selected")
        
        deselectedtokens.append(token)
        selectedTokens = selectedTokens.filter {$0 != token}
    }
    
    // MARK: Table view Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tokens.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellOptional: TokensViewCell! = tableView.dequeueReusableCellWithIdentifier("cell_tokens") as? TokensViewCell
        var cellToken = self.tokens[indexPath.row]
        cellOptional.updateCellWith(cellToken)
        
        if isTokenSelected(cellToken) { cellOptional.onSelected() } else { cellOptional.onDeslected() }
        
        return cellOptional
    }
    
    // MARK: Table view delegates
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as TokensViewCell

        if self.isTokenSelected(cell.token) {
            self.deselectToken(cell.token)
            cell.onDeslected()
        } else {
            self.selectToken(cell.token)
            cell.onSelected()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        updateTopTexts()
    }
    
}
