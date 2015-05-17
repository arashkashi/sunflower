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
    private func dateLastTimeAskedForUserPermission() -> NSDate? {
        return NSUserDefaults.standardUserDefaults().objectForKey(kPermissionAskDate) as? NSDate
    }
    
    private func onAskedUserPermission() {
        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: kPermissionAskDate)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func intervalForAskingPermission() -> NSTimeInterval {
        return 3 * 3600 * 24  // three week
    }
    
    private func isRightTimeForAskingPermission() -> Bool {
        if hasPermission() {
            return false
        }
        
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
    func askUserPermission(viewController: UIViewController) {
        if hasPermission() {
            return
        }
    
        if isRightTimeForAskingPermission() {
            presentCustomUserPermissionrequest(viewController)
        }
    }
    
    private func hasPermission() -> Bool {
        var notificationsSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        if notificationsSettings.types == .None  {
            return false
        } else {
            return true
        }
    }
    
    private func presentCustomUserPermissionrequest(viewController: UIViewController) {
        let alertController = UIAlertController(title: "Permission Request", message: "You learn much faster, if you review few words every day. Would you like Lafro to show a new word once a day?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
            self.systemUserPermissionRequest()
            self.onAskedUserPermission()
            
            var mixPanel = Mixpanel.sharedInstance()
            mixPanel.track("RequestLocalNotif_YES")
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) -> Void in
            self.onAskedUserPermission()
            
            var mixPanel = Mixpanel.sharedInstance()
            mixPanel.track("RequestLocalNotif_NO")
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        viewController.presentViewController(alertController, animated: true) {
        }
    }
    
    private func systemUserPermissionRequest() {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Badge | .Alert | .Sound, categories: nil))
    }
    
    // MARK: schdule notification
    func scheduleNotification(word: Word) {
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        var notificationObj = UILocalNotification()
        notificationObj.timeZone = NSTimeZone.localTimeZone()
        notificationObj.fireDate = NSDate().dateByAddingDays(1)
        notificationObj.alertBody = "Do you know what '\(word.name)' means?"
        notificationObj.alertTitle = "Challenge"
        notificationObj.alertAction = "Review"
        notificationObj.soundName = UILocalNotificationDefaultSoundName
        notificationObj.applicationIconBadgeNumber = 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(notificationObj)
    }
}
