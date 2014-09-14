//
//  LearningPackModel.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit


func < (lhs: LearningPackModel, rhs: LearningPackModel) -> Bool {
    if lhs.lastDateModified == nil && rhs.lastDateModified == nil {
        return true
    }
    
    if lhs.lastDateModified != nil && rhs.lastDateModified == nil {
        if lhs.lastDateModified!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return true
        } else if lhs.lastDateModified!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return false
        }
    }
    
    if lhs.lastDateModified == nil && rhs.lastDateModified != nil {
        if rhs.lastDateModified!.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return true
        } else if lhs.lastDateModified!.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            return false
        }
    }
    
    return lhs.lastDateModified!.compare(rhs.lastDateModified!) == NSComparisonResult.OrderedAscending
}

class LearningPackModel : UIDocument  {
    var id: String
    var words: [Word]
    var lastDateModified: NSDate?
    
    init (id: String, words: [Word]) {
        self.id = id
        self.words = words
        super.init(fileURL: DocumentHelper.localLearningPackURLWithID(id))
    }
}
