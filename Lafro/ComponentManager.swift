//
//  ComponentManager.swift
//  Sunflower
//
//  Created by Arash K. on 12/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class ComponentManager {
    
    var cloudKitManager: CloudKitManager
    var googleTranslator: GoogleTranslate
    var creditManager: CreditManager
    
    
    class var sharedInstance : ComponentManager {
        struct Static {
            static let instance : ComponentManager = ComponentManager()
        }
        return Static.instance
    }
    
    init() {
        cloudKitManager = CloudKitManager.sharedInstance
        googleTranslator = GoogleTranslate.sharedInstance
        creditManager = CreditManager.sharedInstance
    }
    
    func isRunningOnDevice() -> Bool {
        var deviceModel = UIDevice.currentDevice().model
        return deviceModel.hasSuffix("Simulator")
    }
}
