//
//  NetworkManager.swift
//  Lafro
//
//  Created by ArashHome on 10/02/15.
//  Copyright (c) 2015 Arash K. All rights reserved.
//

import Foundation

class NetworkManager {
    
    class var sharedInstance : NetworkManager {
        struct Static {
            static let instance : NetworkManager = NetworkManager()
        }
        return Static.instance
    }
    
    init() {
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
            switch status {
            case AFNetworkReachabilityStatus.NotReachable:
                NSLog("No connection")
                break
            case AFNetworkReachabilityStatus.ReachableViaWiFi:
                NSLog("WiFi")
                break
            case AFNetworkReachabilityStatus.ReachableViaWWAN:
                NSLog("3G")
                break;
            default:
                break;
            }
        }
        
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    
    deinit() {
        AFNetworkReachabilityManager.sharedManager().stopMonitoring()
    }
}
