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
            var wordPack: [Word] = self.wordPackWithID(id)
            var learningPack = LearningPackModel.create(id, words: wordPack, completionHandlerForPersistance: { (success: Bool) -> () in
                // Handle error in case persistance goes wrong
            })
            completionHandler?(learningPack)
        }
    }
    
    func wordPackWithID(id: String) -> [Word] {
        switch id {
        case TestLearningPackIDI:
            return TestLearningPackI.instance().words
        case TestLearningPackIDII:
            return TestLearningPackII.instance().words
        default:
            return TestLearningPackI.instance().words
        }
    }
    
    func hasCashedPackForID(id: String) -> Bool {
        var listOfLocalDocs = self.queryListOfDocsInLocal()
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