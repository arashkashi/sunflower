//
//  ArrayExtension.swift
//  Sunflower
//
//  Created by Arash Kashi on 29/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

extension Array {
    func includes<T : Equatable>(obj: T) -> Bool {
        let filtered = self.filter {$0 as? T == obj}
        return filtered.count > 0
    }
    
    mutating func shuffle() {
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

