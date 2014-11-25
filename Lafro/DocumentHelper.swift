//
//  DocumentHelper.swift
//  Sunflower
//
//  Created by Arash Kashi on 17/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

let fileExtension: String = "lwp";

class DocumentHelper {
    
    class func localDocumentDirectoryURL() -> NSURL? {
        var documentsDirectoryPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        return documentsDirectoryPath
    }
    
    class func cashURLForID(id: String) -> NSURL {
        var baseURL = DocumentHelper.localDocumentDirectoryURL()
        return NSURL(string: "\(id)." + fileExtension, relativeToURL: baseURL)!
    }
}