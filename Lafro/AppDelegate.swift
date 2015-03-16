//
//  AppDelegate.swift
//  Sunflower
//
//  Created by Arash K. on 23/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootNavigationController: UINavigationController?
    var componentManager: ComponentManager = ComponentManager.sharedInstance
    
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        self.rootNavigationController = self.window!.rootViewController as? UINavigationController
        
        // Optional: automatically send uncaught exceptions to Google Analytics.
        GAI.sharedInstance().trackUncaughtExceptions = true
        
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        GAI.sharedInstance().dispatchInterval = 20
        
        // Optional: set Logger to VERBOSE for debug information.
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        
        // Initialize tracker. Replace with your tracking ID.
        GAI.sharedInstance().trackerWithTrackingId("UA-60808157-1")
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Logs 'install' and 'app activate' App Events.
        FBAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Delegate for when the safari return to Lafro from the facebook login.
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    }
    
    
    // MARK: Helper
    func showInformationWithMessage(title: String, message: String) {
        var alertController =  UIAlertController(title: title, message: message, preferredStyle: .ActionSheet )
        
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
        }
        
        alertController.addAction(okAction)
        
        self.rootNavigationController?.visibleViewController.presentViewController(alertController, animated: true, completion: { () -> Void in
            //
        })
    }
}

