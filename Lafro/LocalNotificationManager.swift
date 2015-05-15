//
//  LocalNotificationManager.swift
//  Lafro
//
//  Created by ArashHome on 15/05/15.
//  Copyright (c) 2015 Arash K. All rights reserved.
//

import Foundation

class LocalNotificationManager {
    
    let kPermissionAskDate = "kPermissionAskDate"
    
    // MARK: Permission Timing Logic
    func dateLastTimeAskedForUserPermission() -> NSDate? {
        return NSUserDefaults.standardUserDefaults().objectForKey(kPermissionAskDate) as? NSDate
    }
    
    func onAskedUserPermission() {
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: kPermissionAskDate)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func intervalForAskingPermission() -> NSTimeInterval {
        return 7 * 3600 * 24  // One week
    }
    
    func shouldAskForUserPermission() -> Bool {
        if let lastDateAsked = dateLastTimeAskedForUserPermission() {
            if NSDate(timeInterval: intervalForAskingPermission(), sinceDate: lastDateAsked).isPast() {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    // MARK: Asking permission
    func hasPermission() -> Bool {
        var notificationsSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        if notificationsSettings.types == .None  {
            return false
        } else {
            return true
        }
    }
    
    func customUserPermissionrequest(viewController: UIViewController) {
        let alertController = UIAlertController(title: "Permission Request", message: "You learn more words faster, if you try review quickly every day. Would you want Lafro to show a new word once a day?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
            self.systemUserPermissionRequest()
            self.onAskedUserPermission()
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in
            self.onAskedUserPermission()
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        viewController.presentViewController(alertController, animated: true) {
        }
    }
    
    func systemUserPermissionRequest() {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil))
    }
}
