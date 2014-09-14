//
//  LocalDocPersController.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class LocalDocsPersController: DocPersistanceController {
    
    // #MARK: Interface
    
    func saveLearningPack(learningPackModel: LearningPackModel, completionHandler: ((Bool) -> ())?) {
        // save code here
    }
    
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel) -> ())?) {
        if id == TestLearningPackID {
            completionHandler?(TestLearningPack(id: TestLearningPackID, words: TestLearningPack.words()))
        } else {
            assert(false, "the learning package model was not found.")
        }
    }
    
}
