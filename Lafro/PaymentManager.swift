//
//  PaymentManager.swift
//  Lafro
//
//  Created by ArashHome on 26/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class PaymentManager {
    
    class var sharedInstance : PaymentManager {
        struct Static {
            static let instance : PaymentManager = PaymentManager()
        }
        return Static.instance
    }
   
}
