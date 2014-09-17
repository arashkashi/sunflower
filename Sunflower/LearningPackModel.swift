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
    
    init (id: String, words: [Word]) {
        self.id = id
        self.words = words
        super.init(fileURL: DocumentHelper.localLearningPackURLWithID(id))
    }
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        var data: NSData = contents as NSData
        var loadedModel: LearningPackModel = NSKeyedUnarchiver.unarchiveObjectWithData(data) as LearningPackModel
        
        return true
        
    }
    
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
