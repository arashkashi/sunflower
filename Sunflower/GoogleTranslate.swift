//
//  GoogleTranslate.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kGoogleTranslateSupportedLanaguages = "kGoogleTranslateSupportedLanaguages"

import Foundation

class GoogleTranslate {
    
    let googleAPIKey = "AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8"
    
    let baseTranslationURI = "https://www.googleapis.com/language/translate/v2?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8&source=de&target=en"
    
    let baseSupoprtedLanguagesURL = "https://www.googleapis.com/language/translate/v2/detect?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8&parameters"
    
    class var sharedInstance : GoogleTranslate {
        struct Static {
            static let instance : GoogleTranslate = GoogleTranslate()
        }
        return Static.instance
    }
    
//    # Sample json output
//    # {
//    #   "data": {
//    #     "translations": [
//    #       {
//    #         "translatedText": "I"
//    #       },
//    #       {
//    #         "translatedText": ""
//    #       }
//    #     ]
//    #   }
//    # }
    func translate(text: String, completionHandler:((translation: String?)->())?) {
        var manager = AFHTTPRequestOperationManager()
        manager.GET(self.baseTranslationURI, parameters: ["q" : text], success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            self.handleGoogleResponse(responseObject as NSDictionary, completionHandler: completionHandler)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: %@", error)
                completionHandler?(translation: nil)
        }
    }
    
    func supportedLanagues(completionHandler: (([String]?)->())?) {
        var manager = AFHTTPRequestOperationManager()
        manager.GET(self.baseTranslationURI, parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            var result = responseObject as NSDictionary
            NSDictionary, completionHandler: completionHandler)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: %@", error)
                completionHandler?(nil)
        }
        
    }
    
    func handleGoogleResponse(response: NSDictionary, completionHandler:((translation: String?)->())?) {
        var data = response.objectForKey("data") as? NSDictionary
        var translations = data?.objectForKey("translations") as? NSArray
        
        
        if translations != nil {
            var translation = translations?.objectAtIndex(0) as NSDictionary
            var result = translation.objectForKey("translatedText") as NSString
            completionHandler?(translation: result)
        } else {
            completionHandler?(translation: nil)
        }
    }
    
    // MARK: Supported Languages
    func serverListSupportedLanaguages(completionHandler:(([String]?)->())?) {
        
        
    }
    
    func cashedListSupportedLanguages() -> [String]? {
        return NSUserDefaults.standardUserDefaults().objectForKey(kGoogleTranslateSupportedLanaguages) as? [String]
    }
    
    func updateCashedListSupportedLanguages(supportedLanaguges: [String]) {
        NSUserDefaults.standardUserDefaults().setObject(supportedLanaguges, forKey: kGoogleTranslateSupportedLanaguages)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func supportedLanguages(completionHandler:(([String]?)->())?) {
        if let cashed = self.cashedListSupportedLanguages() {
            completionHandler?(cashed)
        } else {
            self.serverListSupportedLanaguages({ (suppoertedLanaguages: [String]?) -> () in
                if let languages = suppoertedLanaguages {
                    completionHandler?(languages)
                } else {
                    completionHandler?(nil)
                }
            })
        }
    }

}
