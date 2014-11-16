//
//  DiskCache.swift
//  Sunflower
//
//  Created by Arash K. on 16/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


class DiskCache {
    
    class func saveObjectToURL(obj: AnyObject, url: NSURL) {
        NSKeyedArchiver.archiveRootObject(obj, toFile: url.absoluteString)
    }
    
    class func loadObjectFromURL(url: NSURL) -> AnyObject? {
        NSKeyedUnarchiver.unarchiveObjectWithFile(url.absoluteString)
    }
    
    class func deleteCacheAtUrl(url: NSURL) {
        NSFileManager.removeItemAtURL(url)
    }
    
}