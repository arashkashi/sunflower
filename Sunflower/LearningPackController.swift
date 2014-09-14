//
//  LearningPackController.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

var TestLearningPackID: String = "firstPackID"

protocol DocPersistanceController {
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel)->())?) -> ()
    func saveLearningPack(learningPackModel: LearningPackModel, completionHandler: ((Bool)->())?)
}

class LearningPackPersController: DocPersistanceController {
    var cloudDocPersController: CloudDocumentPersistantController
    var localDocPersController: LocalDocsPersController
    
    var listOfAvialablePackIDs: [String] = [TestLearningPackID]
    
    init() {
        self.cloudDocPersController = CloudDocumentPersistantController()
        self.localDocPersController = LocalDocsPersController()
    }
    
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel)->())?) -> () {
        if contains(listOfAvialablePackIDs, id) {
            self.localDocPersController.loadLearningPackWithID(id, completionHandler: completionHandler)
            self.merge(id, completionHanler: nil)
        } else {
            assert(false, "file id is not avaiable")
        }
    }
    
    func saveLearningPack(learningPackModel: LearningPackModel, completionHandler: ((Bool)->())?) {
        self.localDocPersController.saveLearningPack(learningPackModel, completionHandler: completionHandler)
        self.cloudDocPersController.saveLearningPack(learningPackModel, completionHandler: nil)
    }
    
    // #TODO: Move the merge function to the Model
    func merge(id: String, completionHanler: ((Bool) -> ())?) {
        self.localDocPersController.loadLearningPackWithID(id, completionHandler: { (localLearningPackModel: LearningPackModel) -> () in
            var localLearningPackID: String = localLearningPackModel.id
            self.cloudDocPersController.loadLearningPackWithID(localLearningPackID, completionHandler: { (cloudLearningPackModel: LearningPackModel) -> () in
                if cloudLearningPackModel < localLearningPackModel {
                    self.cloudDocPersController.saveLearningPack(localLearningPackModel, completionHanler?)
                } else {
                    self.localDocPersController.saveLearningPack(cloudLearningPackModel, completionHandler: completionHanler?)
                }
            })
        })
    }
        
}