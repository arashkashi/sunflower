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
//                var initialIDs = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16].map{String($0)}
                var initialIDs: [String] = [1].map{String($0)}
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
                var currentIDs = self.listOfAvialablePackIDs
                currentIDs.append(id)
                self.listOfAvialablePackIDs = currentIDs
                completionHandlerForPersistance?(true, model)
            } else {
                completionHandlerForPersistance?(false, nil)
            }
        }
    }
    
    func deletePackage(id: String, completionHandler: ((Bool)->())?) {
        
        // remove it from the file system
        var error: NSErrorPointer = NSErrorPointer()
        loadLearningPackWithID(id, completionHandler: { (lpm: LearningPackModel?) -> () in
            var isSuccessed = NSFileManager.defaultManager().removeItemAtURL(lpm!.fileURL, error: error)
            
            if isSuccessed {
                // remove it from the list of avaiable ids
                self.listOfAvialablePackIDs = self.listOfAvialablePackIDs.filter { $0 != id }
                completionHandler?(true)
            } else {
                completionHandler?(false)
            }
        })
    }
    
    func mergePackages(lmp1: LearningPackModel, lpm2: LearningPackModel, handler: (Bool)->() ) {
        var newID = lmp1.id
        var newWordSet = lmp1.words + lpm2.words
        var newCorpus = LearningPackControllerHelper.merge(lmp1.corpus, corpus2: lpm2.corpus)
        
        self.deletePackage(lmp1.id, completionHandler: { (success: Bool) -> () in
            self.deletePackage(lpm2.id, completionHandler: { (success: Bool) -> () in
                self.addNewPackage(newID, words: newWordSet, corpus: newCorpus, completionHandlerForPersistance: { (success: Bool, lpm: LearningPackModel?) -> () in
                    handler(true)
                })
            })
        })
    }
    
    func renamePackage(oldName: String, newName: String, completionHandler: (()->())? ) {
        self.loadLearningPackWithID(oldName, completionHandler: { (oldLearningPackModel: LearningPackModel?) -> () in
            self.addNewPackage(newName, words: oldLearningPackModel!.words, corpus: oldLearningPackModel!.corpus, completionHandlerForPersistance: { (success: Bool, newLearningPackModel: LearningPackModel?) -> () in
                self.deletePackage(oldName, completionHandler: { (success: Bool) -> () in
                    if success || !success {
                        completionHandler?()
                    }
                })
            })
        })
    }
    
    // Each id should be unique
    func validateID(id: String, existingIDs: [String]) -> String {
        if !existingIDs.includes(id) { return id } else {
            return self.validateID("\(id)I", existingIDs: existingIDs)
        }
    }
    func validateID(id: String) -> String {
        if !listOfAvialablePackIDs.includes(id) { return id } else {
            return self.validateID("\(id)I", existingIDs: listOfAvialablePackIDs)
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
            var temp = (docName.componentsSeparatedByString(".") as! [String])[0]
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
                    result.append(document as! NSString)
                }
            }
        }
        
        return result
    }
}