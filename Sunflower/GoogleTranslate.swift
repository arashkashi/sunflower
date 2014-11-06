//
//  GoogleTranslate.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

let kGoogleTranslateSupportedLanaguages = "kGoogleTranslateSupportedLanaguages"

let ERR_GOOGLE_API_NOT_TRASLATABLE = "ERR_GOOGLE_API_NOT_TRASLATABLE"
let ERR_GOOGLE_API_SUPPORTED_LNG_FAILED = "ERR_GOOGLE_API_SUPPORTED_LNG_FAILED"
let ERR_GOOGLE_API_NETWORD_CONNECTION = "ERR_GOOGLE_API_NETWORD_CONNECTION"

import Foundation

class GoogleTranslate {
    
    let googleAPIKey = "AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8"
    
    let baseTranslationURI = "https://www.googleapis.com/language/translate/v2?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8&source=de&target=en"
    
    let baseSupoprtedLanguagesURL = "https://www.googleapis.com/language/translate/v2/languages?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8&target=en"
    
    class var sharedInstance : GoogleTranslate {
        struct Static {
            static let instance : GoogleTranslate = GoogleTranslate()
        }
        return Static.instance
    }
    
    func translate(text: String, completionHandler:((translation: String?, err: String?)->())?) {
        var manager = AFHTTPRequestOperationManager()
        manager.GET(self.baseTranslationURI, parameters: ["q" : text], success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            self.handleGoogleTranslateResponse(responseObject as NSDictionary, completionHandler: completionHandler)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: %@", error)
                completionHandler?(translation: nil, err: ERR_GOOGLE_API_NETWORD_CONNECTION)
        }
    }
    
    // MARK: Handle Google JSON Response
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
    func handleGoogleTranslateResponse(response: NSDictionary, completionHandler:((translation: String?, err: String?)->())?) {
        var data = response.objectForKey("data") as? NSDictionary
        var translations = data?.objectForKey("translations") as? NSArray
        
        
        if translations != nil {
            var translation = translations?.objectAtIndex(0) as NSDictionary
            var result = translation.objectForKey("translatedText") as NSString
            completionHandler?(translation: result, err: nil)
        } else {
            completionHandler?(translation: nil, err: ERR_GOOGLE_API_NOT_TRASLATABLE)
        }
    }
    
    // {
    //     "data": {
    //         "languages": [
    //             {
    //                 "language": "zh-CN",
    //                 "name": "中文(簡體)"
    //             },
    //             {
    //                 "language": "fr",
    //                 "name": "法文"
    //             },
    //             ...
    //             {
    //                 "language": "en",
    //                 "name": "英文"
    //             }
    //         ]
    //     }
    // }
    func handleGoogleSupportedLanguagesResponse(response: NSDictionary, completionHandler: ((languages: [Dictionary<String, String>]?, err: String?)->())?) {
        var data = response.objectForKey("data") as? NSDictionary
        var languages = data?.objectForKey("languages") as? NSArray
        
        if languages != nil {
            completionHandler?(languages: languages! as? [Dictionary<String, String>], err: nil)
        } else {
            completionHandler?(languages: nil, err: ERR_GOOGLE_API_SUPPORTED_LNG_FAILED)
        }
    }
    
    // MARK: Supported Languages
    func serverListSupportedLanaguages(completionHandler:((supported: [Dictionary<String, String>]?, err: String?)->())?) {
        var manager = AFHTTPRequestOperationManager()
        manager.GET(self.baseSupoprtedLanguagesURL, parameters: nil, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            self.handleGoogleSupportedLanguagesResponse(responseObject as NSDictionary, completionHandler: completionHandler)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: %@", error)
                completionHandler?(supported: nil, err: ERR_GOOGLE_API_NETWORD_CONNECTION)
        }
    }
    
    func cashedListSupportedLanguages() -> [Dictionary<String, String>]? {
        return NSUserDefaults.standardUserDefaults().objectForKey(kGoogleTranslateSupportedLanaguages) as? [Dictionary<String, String>]
    }
    
    func updateCashedListSupportedLanguages(supportedLanaguges: [Dictionary<String, String>]) {
        NSUserDefaults.standardUserDefaults().setObject(supportedLanaguges, forKey: kGoogleTranslateSupportedLanaguages)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func supportedLanguages(completionHandler:(([Dictionary<String, String>]?, err: String?)->())?) {
        if let cashed = self.cashedListSupportedLanguages() {
    completionHandler?(cashed, err: nil)
        } else {
            self.serverListSupportedLanaguages({ (suppoertedLanaguages: [Dictionary<String, String>]?, err: String?) -> () in
                if let languages = suppoertedLanaguages {
                    completionHandler?(languages, err: err)
                } else {
                    completionHandler?(nil, err: err)
                }
            })
        }
    }

}
