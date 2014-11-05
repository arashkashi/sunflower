//
//  GoogleTranslate.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class GoogleTranslate {
    
    let baseURI = "https://www.googleapis.com/language/translate/v2?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8&source=de&target=en"
    
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
        manager.GET(self.baseURI, parameters: ["q" : text], success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            self.handleGoogleResponse(responseObject as NSDictionary, completionHandler: completionHandler)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: %@", error)
                completionHandler?(translation: nil)
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

}
