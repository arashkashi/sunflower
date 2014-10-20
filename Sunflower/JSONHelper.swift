//
//  JSONHelper.swift
//  Sunflower
//
//  Created by Arash Kashi on 20/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


class JSONHelper {
    
    class func listFromJSONFile(filename: String) -> NSArray? {
        if let data = JSONHelper.dataFromJSONFile(filename) as? NSData {
            return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSArray
        }
        return nil
    }
    
    class func hashFromJSONFile(filename: String) -> NSDictionary? {
        if let data = JSONHelper.dataFromJSONFile(filename) as? NSData {
            return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary
        }
        return nil
    }
    
    class func dataFromJSONFile(filename: String) -> AnyObject? {
        if let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: "json")? {
            var data = NSData.dataWithContentsOfFile(filePath, options: NSDataReadingOptions.allZeros, error: nil)
            return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
        }
        return nil
    }
}