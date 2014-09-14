//
//  DocumentHelper.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class DocumentHelper {
    class func localDocumentDirectoryURL() -> NSURL {
        return DocumentHelper.localLearningPackURLWithID("")
    }
    
    class func localLearningPackURLWithID(id: String) -> NSURL{
        var documentDirectoryPath: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        return NSURL(fileURLWithPath:documentDirectoryPath + id)
    }
}
