//
//  Transaction.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class Transaction {
    var type: TransactionType
    var amount: Int
    
    init(type: TransactionType, amount: Int) {
        self.type = type
        self.amount = amount
    }
}
