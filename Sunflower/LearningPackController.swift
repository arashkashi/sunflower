//
//  LearningPackController.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation


class LearningPackPersController {
    
    var listOfAvialablePackIDs: [String] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16].map{String($0)}
    var query: NSMetadataQuery?
    
    class var sharedInstance : LearningPackPersController {
    struct Static {
        static let instance : LearningPackPersController = LearningPackPersController()
        }
        return Static.instance
    }
    
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel?)->())?) {
        if self.hasCashedPackForID(id) {
            self.loadLocalCachWithID(id, completionHandler: completionHandler)
        } else {
            var words = RawPackage.packWithID(id)!
            LearningPackModel.create(id, words: words, completionHandlerForPersistance: { (success: Bool, model: LearningPackModel?) -> () in
                if (success) {
                    completionHandler?(model)
                } else {
                    completionHandler?(nil)
                }
            })
        }
    }
    
    func hasCashedPackForID(id: String) -> Bool {
        var listOfLocalDocs = self.queryListOfDocsInLocal()
        for docName in listOfLocalDocs {
            var temp = (docName.componentsSeparatedByString(".") as [String])[0]
            if temp == id {
                return true
            }
        }
        return false
    }
    
    func loadLocalCachWithID(id: String, completionHandler: ((LearningPackModel)->())?) {
        LearningPackModel.open(id, completionHandler: completionHandler)
    }
    
    // #MARK : Query local and cloud documents
    func queryListOfDocsInLocal() -> [NSString]  {
        var result: [NSString] = []
        if let docURL = DocumentHelper.localDocumentDirectoryURL() {
            var localDocs = NSFileManager.defaultManager().contentsOfDirectoryAtPath(docURL.path!, error: nil)
            
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