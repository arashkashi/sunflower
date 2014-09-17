//
//  DocumentHelper.swift
//  Sunflower
//
//  Created by Arash Kashi on 17/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class DocumentHelper {
    class func localDocumentDirectoryURL() -> NSURL {
        var documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        return NSURL.fileURLWithPath(documentsDirectoryPath)!
    }
}
