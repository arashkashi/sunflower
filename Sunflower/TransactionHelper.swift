//
//  TransactionHelper.swift
//  Sunflower
//
//  Created by Arash K. on 15/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation



enum TransactionStatus: Int32 {
    case pending_local_write
    case pending_server_write
    case pending_server_local_write
    case commited
    
    func isPending() -> Bool {
        return self != .commited
    }
    
    mutating func onSuccessfulLocalWrite() {
        switch self {
        case .pending_local_write:
            self = .commited
        case .pending_server_local_write:
            self = .pending_server_write
        default:
            return
        }
    }
    
    mutating func onSuccessfulServerWrite() {
        switch self {
        case .pending_server_write:
            self = .commited
        case .pending_server_local_write:
            self = .pending_local_write
        default:
            return
        }
        
    }
    
    static func initialStatus(type: TransactionType) ->  TransactionStatus{
        if type == .grant_locallyNo_serverLazy {
            return .pending_server_write
        } else {
            return .pending_server_local_write
        }
    }
    
    func toInt32 () -> Int32 {
        switch self {
        case .pending_local_write:
            return 1
        case .pending_server_write:
            return 2
        case .pending_server_local_write:
            return 3
        default:
            return 0
        }
    }
    
    static func initWithInt(intInput: Int32) -> TransactionStatus {
        switch intInput {
        case 1:
            return .pending_local_write
        case 2:
            return .pending_server_write
        case 3:
            return .pending_server_local_write
        default:
            assert(false, "type is not supported")
            return .pending_server_local_write
        }
    }
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