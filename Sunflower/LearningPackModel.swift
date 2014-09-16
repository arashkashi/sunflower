//
//  LearningPackModel.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit


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
        aCoder.encodeObject(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        var learningPackModel: LearningPackModel = aDecoder.decodeObject() as LearningPackModel
        self.id = learningPackModel.id
        self.words = learningPackModel.words
        super.init()
    }
}
