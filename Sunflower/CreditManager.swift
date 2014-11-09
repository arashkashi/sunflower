//
//  CreditManager.swift
//  Sunflower
//
//  Created by Arash K. on 08/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kCreditManagerBalance = "kCreditManagerBalance"

typealias Lafru = Int
typealias Dollar = Double

import Foundation

class CreditManager {
    
    var balance: Lafru
    let initialBalance: Lafru = 5000
    
    let costPerCharacter = 0.0002
    
    class var sharedInstance : CreditManager {
        struct Static {
            static let instance : CreditManager = CreditManager()
        }
        return Static.instance
    }
    
    func lafruToDollar(amount: Lafru) -> Dollar {
        return  Double(amount) * self.costPerCharacter
    }
    
    func dollarToLafru(dollar: Dollar) -> Lafru {
        return (Lafru)(Double(dollar) / self.costPerCharacter)
    }
    
    init() {
        self.balance = self.initialBalance
    }
    
    func spend(amount: Lafru) {
        balance = balance - amount
    }
    
    func charge(amount: Lafru) {
        balance = balance + amount
    }
    
    func hasCreditFor(amount: Lafru) -> Bool {
        return amount < balance
    }
}
