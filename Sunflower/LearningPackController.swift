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
    
    class var sharedInstance : LearningPackPersController {
    struct Static {
        static let instance : LearningPackPersController = LearningPackPersController()
        }
        return Static.instance
    }
    
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel)->())?) {
        if self.hasCashedPackForID(id) {
            self.loadLocalCachWithID(id, completionHandler: completionHandler)
        } else {
            var learningPack = LearningPackModel.create(id, completionHandlerForPersistance: { (success: Bool) -> () in
                // Handle error in case persistance goes wrong
            })
            completionHandler?(learningPack)
        }
    }
    
    func hasCashedPackForID(id: String) -> Bool {
        var listOfLocalDocs = self.queryListOfDocsInLocal()
        return listOfLocalDocs.count > 0
    }
    
    func loadLocalCachWithID(id: String, completionHandler: ((LearningPackModel)->())?) {
        LearningPackModel.open(id, completionHandler: completionHandler)
    }
    
    // #MARK : Query local and cloud documents
    func queryListOfDocsInLocal() -> [NSString]  {
        var result: [NSString] = []
        var docURL: NSURL? = DocumentHelper.localDocumentDirectoryURL()
        if docURL != nil {
            var localDocs = NSFileManager.defaultManager().contentsOfDirectoryAtPath(docURL!.path!, error: nil)
            
            if localDocs != nil {
                for document in localDocs! {
                    result.append(document as NSString)
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