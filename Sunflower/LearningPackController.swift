//
//  LearningPackController.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

var TestLearningPackID: String = "TestLearningPack"



class LearningPackPersController {
    
    var listOfAvialablePackIDs: [String] = [TestLearningPackID]
    var query: NSMetadataQuery?
    
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel)->())?) -> () {
        if self.hasCashedModelForID(id) {
            self.loadLocalCachWithID(id, completionHandler: completionHandler)
        } else {
            completionHandler?(self.rawLearningPackWithID(id))
        }
    }
    
    func rawLearningPackWithID(id: String) -> LearningPackModel {
        switch id {
        case TestLearningPackID:
            return TestLearningPack.instance()
        default:
            return TestLearningPack.instance()
        }
    }
    
    func hasCashedModelForID(id: String) -> Bool {
        return false
    }
    
    func loadLocalCachWithID(id: String, completionHandler: ((LearningPackModel)->())?) {
        
    }
    
    // #MARK : Query local and cloud documents
    func queryListOfDocsInCloud() {
        self.query = NSMetadataQuery()
        self.query!.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cloudFileListReceived:", name:NSMetadataQueryDidFinishGatheringNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cloudFileListReceived:", name:NSMetadataQueryDidUpdateNotification, object: nil)
        self.query!.startQuery()
    }
    
    func queryListOfDocsInLocal() -> [String]  {
        var result: [String] = []
        var localDocs = NSFileManager.defaultManager().contentsOfDirectoryAtPath(DocumentHelper.localDocumentDirectoryURL().path!, error: nil)
        for document in localDocs as [String] {
            result.append(document)
        }
        return result
    }
    
    func cloudFileListReceived() {
        var queryResults = self.query!.results
        assert(false, "pending implementation")
    }
}