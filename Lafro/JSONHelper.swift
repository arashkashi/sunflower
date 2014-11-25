//
//  JSONHelper.swift
//  Sunflower
//
//  Created by Arash Kashi on 20/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


class JSONHelper {
    class func hashFromJSONFile(filename: String) -> NSDictionary? {
        if let data = JSONHelper.dataFromJSONFile(filename) {
            return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary
        } else {
            return nil
        }
    }
    
    class func listFromJSONFile(filename: String) -> NSArray? {
        if let data = JSONHelper.dataFromJSONFile(filename) {
            return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSArray
        } else {
            return nil
        }
    }
    
    class func dataFromJSONFile(filename: String) -> NSData? {
        if let filePath = NSBundle.mainBundle().pathForResource(filename, ofType: "json")? {
            var temp =  NSData(contentsOfFile: filePath, options: NSDataReadingOptions.allZeros, error: nil)// (contentsOfFile: filePath)
            return temp
        } else {
            return nil
        }
    }
}