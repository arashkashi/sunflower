//
//  TransactionHelper.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

func == (lhs: Transaction, rhs: Transaction) -> Bool {
    return lhs.createDate.isEqualToDate(rhs.createDate)
}

enum TransactionType: Int32 {
    case grant_locallyNow_serverLazy
    case grant_locallyNow_serverNow
    case grant_locallyNo_serverLazy
    
    func toInt32 () -> Int32 {
        switch self {
        case .grant_locallyNow_serverLazy:
            return 1
        case .grant_locallyNow_serverNow:
            return 2
        case .grant_locallyNo_serverLazy:
            return 3
        }
    }
    
    static func initWithInt(intInput: Int32) -> TransactionType {
        switch intInput {
        case 1:
            return .grant_locallyNow_serverLazy
        case 2:
            return .grant_locallyNow_serverNow
        case 3:
            return .grant_locallyNo_serverLazy
        default:
            assert(false, "type is not supported")
            return .grant_locallyNow_serverNow
        }
    }
    
    func shouldGrantLocallyNow() -> Bool {
        return !(self == .grant_locallyNo_serverLazy)
    }
    
    func shouldGrantServerLazy() -> Bool {
        if self == .grant_locallyNow_serverLazy || self == .grant_locallyNo_serverLazy { return true }
        return false
    }
    
    func shouldGrantServerNow() -> Bool {
        if self == .grant_locallyNow_serverNow { return true }
        return false
    }
}