//
//  CreditManager.swift
//  Sunflower
//
//  Created by Arash K. on 08/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kCreditManagerBalance = "kCreditManagerBalance"

import Foundation

class CreditManager {
    
    var balance: Int
    let initialBalance = 5000
    
    class var sharedInstance : CreditManager {
        struct Static {
            static let instance : CreditManager = CreditManager()
        }
        return Static.instance
    }
    
    init() {
        self.balance = self.initialBalance
    }
    
    func spend(amount: Int) {
        balance = balance - amount
    }
    
    func charge(amount: Int) {
        balance = balance + amount
    }
    
    func hasCreditFor(amount: Int) -> Bool {
        return amount < balance
    }
}
