//
//  StringExtension.swift
//  Sunflower
//
//  Created by Arash K. on 20/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

extension String {
    
    func length() -> Int {
        var counter: Int = 0
        for character in self {
            counter = counter + 1 
        }
        return counter
    }
}


