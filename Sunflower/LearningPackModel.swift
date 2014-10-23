//
//  LearningPackModel.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

let kWordsKey: String = "kWords"
let kIDKey: String = "kID"


class LearningPackModel : UIDocument, NSCoding  {
    var id: String
    var words: [Word]
    
    override var fileURL: NSURL {
        get {
            return DocumentHelper.cashURLForID(self.id)
        }
    }
    
    init (id: String, words: [Word]) {
        self.id = id
        self.words = words
        super.init(fileURL: DocumentHelper.cashURLForID(id))
    }
    
    // #MARK: Document Facade
    class func create(id: String, words: [Word], completionHandlerForPersistance: ((Bool, LearningPackModel?) -> ())?) {
        var learningPackModel = LearningPackModel(id: id, words: words)
        learningPackModel.saveToURL(learningPackModel.fileURL, forSaveOperation: .ForCreating) { (success: Bool) -> Void in
            if (success) {
                completionHandlerForPersistance?(true, learningPackModel)
            } else {
                completionHandlerForPersistance?(false, nil)
            }
        }
    }
    
    class func open(id: String, completionHandler: ((LearningPackModel) -> ())? ) {
        var document = LearningPackModel(id: id, words: [])
        document.openWithCompletionHandler { (finished: Bool) -> Void in
            if finished {
                completionHandler?(document)
            }
        }
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
        super.init(fileURL: DocumentHelper.cashURLForID(self.id))
    }
}
