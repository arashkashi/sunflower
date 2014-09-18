//
//  LearningPackController.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

var TestLearningPackIDI: String = "TestLearningPackI"
var TestLearningPackIDII: String = "TestLearningPackII"



class LearningPackPersController {
    
    var listOfAvialablePackIDs: [String] = [TestLearningPackIDI, TestLearningPackIDII]
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
        case TestLearningPackIDI:
            return TestLearningPackI.instance()
        case TestLearningPackIDII:
            return TestLearningPackII.instance()
        default:
            return TestLearningPackI.instance()
        }
    }
    
    func hasCashedModelForID(id: String) -> Bool {
        return false
    }
    
    func loadLocalCachWithID(id: String, completionHandler: ((LearningPackModel)->())?) {
        
    }
    
    // #MARK : Query local and cloud documents
    func queryListOfDocsInLocal() -> [String]  {
        var result: [String] = []
        var docURL: NSURL? = DocumentHelper.localDocumentDirectoryURL()
        if docURL != nil {
            var localDocs = NSFileManager.defaultManager().contentsOfDirectoryAtPath(docURL!.path!, error: nil)
            
            if localDocs != nil {
                for document in localDocs! {
                    result.append(document as String)
                }
            }
        }
        
        return result
    }
    
    func cloudFileListReceived(notification: NSNotification) {
//        var queryResults = self.query!.results
//        assert(false, "pending implementation")
    }
    
    func queryListOfDocsInCloud() {
//        self.query = NSMetadataQuery()
//        self.query!.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("cloudFileListReceived:"), name:NSMetadataQueryDidFinishGatheringNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("cloudFileListReceived:"), name:NSMetadataQueryDidUpdateNotification, object: nil)
//        self.query!.startQuery()
    }
}