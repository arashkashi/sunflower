//
//  CKRecordExtension.swift
//  Lafro
//
//  Created by Arash K. on 15/03/15.
//  Copyright (c) 2015 Arash K. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {
    
    func keysInString() {
        for key in self.allKeys() {
            var valueInNumber = self.objectForKey(key as! String) as? NSNumber
            
            if let value = valueInNumber {
                println("\(key) -> \(value)")
            } else {
                println("\(key) -> 'value not string convertable'")
            }
        }
    }
}
