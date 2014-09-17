//
//  LearningPackModel.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

let kWordsKey: String = "kWordsKey"
let kIDKey: String = "kIDKey"


class LearningPackModel : UIDocument, NSCoding  {
    var id: String
    var words: [Word]
    
    var localDocumentsDirectoryURL: NSURL?
    let fileExtension: String = "lwp";
    
    
    init (id: String, words: [Word]) {
        self.id = id
        self.words = words
        super.init(fileURL: DocumentHelper.localLearningPackURLWithID(id))
    }
    
    class func create(id: String, words: [Word]) {
        var result = LearningPackModel(id: id, words: words)
    }
    
    class func fileURL() -> NSURL {
        var path = LearningPackModel.localDocumentDirectoryURL()
        path.file
    }
    
    // #MARK: UIDocument Overwrites
    override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        var data: NSData = contents as NSData
        var loadedModel: LearningPackModel = NSKeyedUnarchiver.unarchiveObjectWithData(data) as LearningPackModel
        
        return true
    }
    
    override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
    
    // #MARK: Helper
    class func localDocumentDirectoryURL() -> NSURL {
        if (self.localDocumentsDirectoryURL == nil) {
            var documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
            self.localDocumentsDirectoryURL = NSURL.fileURLWithPath(documentsDirectoryPath)
        }
        return self.localDocumentsDirectoryURL!;
    }
    
    // #MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.words, forKey: kWordsKey)
        aCoder.encodeObject(self.id, forKey: kIDKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.words = aDecoder.decodeObjectForKey(kWordsKey) as Array
        self.id = aDecoder.decodeObjectForKey(kIDKey) as String
        super.init()
    }
}
