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
    
    var localBalance: Lafru {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(kCreditManagerBalance)
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: kCreditManagerBalance)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    let initialBalance: Lafru = 5000
    let costPerCharacter = 0.0002
    
    func spend(amount: Lafru) {
        localBalance = localBalance - amount
    }
    
    func charge(amount: Lafru) {
        localBalance = localBalance + amount
    }
    
    func hasCreditFor(amount: Lafru) -> Bool {
        return amount < localBalance
    }
    
    // MARK: Server Calls
    func askServerIfInitialCreditGranted( handler: (Bool)->() ) {
        
    }
    
    func grantInitialCreditToServer(initialCredit: Int, handler: ()->() ) {
        
    }
    
    //  MARK: Helper
    func lafruToDollar(amount: Lafru) -> Dollar {
        return  Double(amount) * self.costPerCharacter
    }
    
    func dollarToLafru(dollar: Dollar) -> Lafru {
        return (Lafru)(Double(dollar) / self.costPerCharacter)
    }
    
    // MARK: Initiation
    class var sharedInstance : CreditManager {
        struct Static {
            static let instance : CreditManager = CreditManager()
        }
        return Static.instance
    }
    
    init() {
        localBalance = self.initialBalance
    }
}
