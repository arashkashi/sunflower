//
//  TransactionHelper.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


enum TransactionType: Int32 {
    case grant_only_locally
    case grant_only_server
    case grant_both
    
    func toInt () -> Int32 {
        switch self {
        case .grant_only_locally:
            return 1
        case .grant_only_server:
            return 2
        case .grant_both:
            return 3
        }
    }
    
    static func initWithInt(intInput: Int32) -> TransactionType {
        switch intInput {
        case 1:
            return .grant_only_locally
        case 2:
            return .grant_only_server
        case 3:
            return .grant_both
        default:
            assert(false, "type is not supported")
            return .grant_only_locally
        }
    }
    
    func shouldGrantLocally() -> Bool {
        if self == .grant_only_locally || self == .grant_both { return true }
        return false
    }
    
    func shouldGrantServer() -> Bool {
        if self == .grant_only_server || self == .grant_both { return true }
        return false
    }
}