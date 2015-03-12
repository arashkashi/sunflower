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
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIF_REACHABILITY_CHANGE, object: nil, userInfo: [NOTIF_USER_INFO_REACHBILITYCHANGE: NOTIF_REACHABILITY_CHANGE_NO_CONNECTION])
//                NSLog("No connection")
                break
            case AFNetworkReachabilityStatus.ReachableViaWiFi:
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIF_REACHABILITY_CHANGE, object: nil, userInfo: [NOTIF_USER_INFO_REACHBILITYCHANGE: NOTIF_REACHABILITY_CHANGE_WIFI])
//                NSLog("WiFi")
                break
            case AFNetworkReachabilityStatus.ReachableViaWWAN:
                NSNotificationCenter.defaultCenter().postNotificationName(NOTIF_REACHABILITY_CHANGE, object: nil, userInfo: [NOTIF_USER_INFO_REACHBILITYCHANGE: NOTIF_REACHABILITY_CHANGE_WWLAN])
//                NSLog("3G")
                break;
            default:
                break;
            }
        }
        
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    
    func networkStatus() -> AFNetworkReachabilityStatus {
        return AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus
    }
    
    deinit {
        AFNetworkReachabilityManager.sharedManager().stopMonitoring()
    }
}
