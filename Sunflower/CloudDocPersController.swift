//
//  CloudManager.swift
//  Sunflower
//
//  Created by Arash Kashi on 12/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation
import UIKit

class CloudDocumentPersistantController: DocPersistanceController{
    var isCloudEnabled: Bool = false
    var dataDirectoryURL: NSURL?
    var documentDirectoryURL: NSURL?
    
    init () {
        
    }
    
    class func sharedInstance() -> CloudDocumentPersistantController {
        return CloudDocumentPersistantController()
    }
    
    func checkUserPreferenceAndSetupIcloudIfNecessary () {
        var currentToken = NSFileManager.defaultManager().ubiquityIdentityToken
        var userDefault = NSUserDefaults.standardUserDefaults()
        var userIcloudChoice: String? = userDefault.stringForKey("com.apple.CloudNotes.UseICloudStorage")
        
        if (currentToken != nil) {
            if (userIcloudChoice == nil) {
                // #TODO: UIAlertView is deprecated in iOS 8
//                var alertView = UIAlertView(title: "Choose storage option", message: "Should documents be sotred in iCloud or in just this device", delegate: self, cancelButtonTitle: "Local Only", otherButtonTitles: "iCloud", nil)
//                alert.show()
                
            } else if (userIcloudChoice == "YES") {
                CloudDocumentPersistantController.sharedInstance().isCloudEnabled = true
            }
        } else {
            CloudDocumentPersistantController.sharedInstance().isCloudEnabled = false
        }
    }
    
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel) -> ())?) {
        // load code
    }
    
    func saveLearningPack(learningPackModel: LearningPackModel, completionHandler: ((Bool) -> ())?) {
        // saving code
    }
}
