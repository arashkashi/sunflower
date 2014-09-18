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
    
    let fileExtension: String = "lwp";
    override var fileURL: NSURL {
        get {
            var baseURL = DocumentHelper.localDocumentDirectoryURL()
            return NSURL.URLWithString("\(self.id)." + self.fileExtension, relativeToURL: baseURL)
        }
    }
    
    init (id: String, words: [Word]) {
        self.id = id
        self.words = words
        super.init(fileURL: self.fileURL)
    }
    
    // #MARK: Document Facade
    class func create(id: String, words: [Word], completionHandlerForPersistance: ((Bool) -> ())?) -> LearningPackModel {
        var result = LearningPackModel(id: id, words: words)
        result.saveToURL(result.fileURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: completionHandlerForPersistance)
        return result
    }
    
    class func open(id: String, completionHandler: ((Bool) -> Void)? ) {
        var document = LearningPackModel(id: id, words: [])
        document.openWithCompletionHandler(completionHandler)
    }
    
    class func close(id: String,  completionHandler: ((Bool) -> Void)?) {
        var document = LearningPackModel(id: id, words: [])
        document.closeWithCompletionHandler(completionHandler)
    }
    
    // #MARK: UIDocument Overwrites
    override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        var data: NSData = contents as NSData
        var loadedModel: LearningPackModel = NSKeyedUnarchiver.unarchiveObjectWithData(data) as LearningPackModel
        
        self.id = loadedModel.id
        self.words = loadedModel.words
        
        return true
    }
    
    override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
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
