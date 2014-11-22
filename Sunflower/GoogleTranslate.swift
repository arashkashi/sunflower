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
let ERR_GOOGLE_API_LANGUAGE_NOT_DETECTED = "ERR_GOOGLE_API_LANGUAGE_NOT_DETECTED"

import Foundation

class GoogleTranslate {
    
    let googleAPIKey = "AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8"
    let baseTranslationURI = "https://www.googleapis.com/language/translate/v2?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8"
    let baseSupoprtedLanguagesURL = "https://www.googleapis.com/language/translate/v2/languages?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8&target=en"
    let baseDetectLanguageURI = "https://www.googleapis.com/language/translate/v2/detect?key=AIzaSyAI21c0KYKv4dMZPQeVy3R9ZA17AfOQNy8"
    
     // in dollars
    
    class var sharedInstance : GoogleTranslate {
        struct Static {
            static let instance : GoogleTranslate = GoogleTranslate()
        }
        return Static.instance
    }
    
    func costToTranslate(text: String) -> Lafru {
        var counter: Lafru = 0
        for character in text {
            counter++
        }
        return counter
    }
    
    func costToTranslate(tokens: [String]) -> Lafru {
        var cost: Lafru = 0
        for token in tokens {
            cost = cost + self.costToTranslate(token)
        }
        return cost
    }
    
    func detectLanaguage(text: String, completionHandler:((detectedLanguage: String?, err: String?)->())?) {
        
        AFHTTPRequestOperationManager().GET(self.baseDetectLanguageURI, parameters: ["q" : text], success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            var result = self.handleGoogleDetectLanagugeReposne(responseObject as NSDictionary)
            var detectedLanguage = result.detectedLanguage
            
            if detectedLanguage != nil {
                completionHandler?(detectedLanguage: detectedLanguage!, err: nil)
            } else {
                completionHandler?(detectedLanguage: nil, err: ERR_GOOGLE_API_SUPPORTED_LNG_FAILED)
            }
            
            }) { (operaion: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                completionHandler?(detectedLanguage: nil, err: ERR_GOOGLE_API_NETWORD_CONNECTION)
        }
    }
    
    func translate(text: String, targetLanguage: String, sourceLanaguage: String, translateEndHandler:((translation: String?, err: String?, cost: Lafru)->())?) {
        AFHTTPRequestOperationManager().GET(self.baseTranslationURI, parameters: ["q" : text, "target": targetLanguage, "source": sourceLanaguage], success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            var cost = self.costToTranslate(text)
            var result = self.handleGoogleTranslateResponse(responseObject as NSDictionary)
            
            if result.translation != nil {
                translateEndHandler?(translation:result.translation!, err: nil, cost: cost)
            } else {
                translateEndHandler?(translation: nil, err: ERR_GOOGLE_API_NOT_TRASLATABLE, cost: cost)
            }
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
//                translateEndHandler?(translation: nil, err: ERR_GOOGLE_API_NETWORD_CONNECTION, cost: 0)
        }
    }
    
    // MARK: Handle Google JSON Response

//    {
//        "data": {
//            "detections": [
//                [
//                    {
//                        "language": "en",
//                        "isReliable": false,
//                        "confidence": 0.18397073
//                    }
//                ]
//            ]
//        }
//    }
    func handleGoogleDetectLanagugeReposne(response: NSDictionary) -> (detectedLanguage: String?, err: String?) {
        var data = response.objectForKey("data") as? NSDictionary
        var detections = data?.objectForKey("detections") as? NSArray
        
        if detections != nil && detections?.count > 0 {
            var temp = detections!.objectAtIndex(0) as? NSArray
            var detectionDict = temp!.objectAtIndex(0) as? NSDictionary
            var detectedLanguage = detectionDict?.objectForKey("language") as? String
            
            if detectedLanguage != nil {
                return (detectedLanguage!, nil)
            } else {
                return (nil, ERR_GOOGLE_API_LANGUAGE_NOT_DETECTED)
            }
        } else {
            return (nil, ERR_GOOGLE_API_LANGUAGE_NOT_DETECTED)
        }
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
    func handleGoogleTranslateResponse(response: NSDictionary) -> (translation: String?, err: String?) {
        var data = response.objectForKey("data") as? NSDictionary
        var translations = data?.objectForKey("translations") as? NSArray
        
        
        if translations != nil {
            var translation = translations?.objectAtIndex(0) as NSDictionary
            var result = translation.objectForKey("translatedText") as NSString
            
            if result != "" {
                return (result, nil)
            } else {
                return (nil, ERR_GOOGLE_API_NOT_TRASLATABLE)
            }
            
        } else {
            return (nil, ERR_GOOGLE_API_NOT_TRASLATABLE)
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
            self.updateCashedListSupportedLanguages(languages as [Dictionary<String, String>])
            completionHandler?(languages: languages! as? [Dictionary<String, String>], err: nil)
        } else {
            completionHandler?(languages: nil, err: ERR_GOOGLE_API_SUPPORTED_LNG_FAILED)
        }
    }
    
    // MARK: Locally Cashed Supported Languages
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
