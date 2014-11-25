//
//  LearningPackControllerSkipHelper.swift
//  Lafro
//
//  Created by ArashHome on 25/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

let kLearningPackControllerSkipHelperPackID = "kLearningPackControllerSkipHelperPackID"

class LearningPackControllerSkipHelper {
    
    // Load the learning pack model
    class func loadSkipLearningPackModel( completionHandler: ((LearningPackModel!)->())? ) {
        
        var mainController = LearningPackController.sharedInstance
        
        if mainController.hasCashedPackForID(kLearningPackControllerSkipHelperPackID)
        {
            mainController.loadLocalCachWithID(kLearningPackControllerSkipHelperPackID, completionHandler: completionHandler)
        }
        else
        {
            LearningPackModel.create(kLearningPackControllerSkipHelperPackID, words: [], corpus: nil, completionHandlerForPersistance: { (success: Bool, model: LearningPackModel?) -> () in
                if (success) {
                    completionHandler?(model)
                } else {
                    completionHandler?(nil)
                }
            })
        }
    }
}
