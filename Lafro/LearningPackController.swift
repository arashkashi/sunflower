//
//  LearningPackController.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

let kAvaialblePackageIDs = "kAvaialblePackageIDs"


class LearningPackController {
    
    var listOfAvialablePackIDs: [String] {
        get {
            var ids = NSUserDefaults.standardUserDefaults().objectForKey(kAvaialblePackageIDs) as? [String]
            if ids == nil {
                var initialIDs = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16].map{String($0)}
                NSUserDefaults.standardUserDefaults().setObject(initialIDs, forKey: kAvaialblePackageIDs)
                NSUserDefaults.standardUserDefaults().synchronize()
                return initialIDs
            } else {
                return ids!
            }
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: kAvaialblePackageIDs)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var query: NSMetadataQuery?
    
    class var sharedInstance : LearningPackController {
    struct Static {
        static let instance : LearningPackController = LearningPackController()
        }
        return Static.instance
    }
    
    func addNewPackage(id: String, words: [Word], corpus: String?, completionHandlerForPersistance: ((Bool, LearningPackModel?) -> ())?) {
        LearningPackModel.create(id, words: words, corpus: corpus) { (success: Bool, model: LearningPackModel?) -> () in
            if success {
                completionHandlerForPersistance?(true, model)
                var currentIDs = self.listOfAvialablePackIDs
                currentIDs.append(id)
                self.listOfAvialablePackIDs = currentIDs
            } else {
                completionHandlerForPersistance?(false, nil)
            }
        }
    }
    
    func validateID(id: String, existingIDs: [String]) -> String {
        if !existingIDs.includes(id) { return id } else {
            return self.validateID("\(id)I", existingIDs: existingIDs)
        }
    }
    
    func loadLearningPackWithID(id: String, completionHandler: ((LearningPackModel?)->())?) {
        if self.hasCashedPackForID(id) {
            self.loadLocalCachWithID(id, completionHandler: completionHandler)
        } else {
            var words = RawPackage.packWithID(id)!
            LearningPackModel.create(id, words: words, corpus: nil, completionHandlerForPersistance: { (success: Bool, model: LearningPackModel?) -> () in
                if (success) {
                    completionHandler?(model)
                } else {
                    completionHandler?(nil)
                }
            })
        }
    }
    
    // MARK: Caching
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
    
    // MARK: Query local and cloud documents
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
}