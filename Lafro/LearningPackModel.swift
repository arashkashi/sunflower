//
//  LearningPackModel.swift
//  Sunflower
//
//  Created by Arash Kashi on 14/09/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

let kLearingPackModelWords: String = "kkLearingPackModelWords"
let kLearingPackModelID: String = "kLearingPackModelID"
let kLearingPackModelCorpus: String = "kLearingPackModelCorpus"


class LearningPackModel : UIDocument, NSCoding  {
    var id: String
    var words: [Word]
    var corpus: String?
    
    var progress: Double {
        get {
            var wordsInFuture = words.filter{($0 as Word).isDueInFuture()}
            return Double(wordsInFuture.count)/Double(words.count) * 100
        }
    }
    
    override var fileURL: NSURL {
        get {
            return DocumentHelper.cashURLForID(self.id)
        }
    }
    
    init (id: String, words: [Word], corpus: String?) {
        self.id = id
        self.words = words
        self.corpus = corpus
        super.init(fileURL: DocumentHelper.cashURLForID(id))
    }
    
    func wordsDueInFuture() -> [Word] {
        var result: [Word] = []
        for word in self.words {
            if let relearnDate = word.relearningDueDate {
                if relearnDate.isFuture() {
                    result.append(word)
                }
            }
        }
        return result
    }
    
    // #MARK: Document Facade
    class func create(id: String, words: [Word], corpus: String?, completionHandlerForPersistance: ((Bool, LearningPackModel?) -> ())?) {
        var learningPackModel = LearningPackModel(id: id, words: words, corpus: corpus)
        learningPackModel.saveToURL(learningPackModel.fileURL, forSaveOperation: .ForCreating) { (success: Bool) -> Void in
            if (success) {
                completionHandlerForPersistance?(true, learningPackModel)
            } else {
                completionHandlerForPersistance?(false, nil)
            }
        }
    }
    
    class func open(id: String, completionHandler: ((LearningPackModel) -> ())? ) {
        var document = LearningPackModel(id: id, words: [], corpus: nil)
        document.openWithCompletionHandler { (finished: Bool) -> Void in
            if finished {
                completionHandler?(document)
            }
        }
    }
    
    class func close(id: String,  completionHandler: ((Bool) -> Void)?) {
        var document = LearningPackModel(id: id, words: [], corpus: nil)
        document.closeWithCompletionHandler(completionHandler)
    }
    
    func saveChanges() {
        self.updateChangeCount(UIDocumentChangeKind.Done)
    }
    
    // #MARK: UIDocument Overwrites
    override func loadFromContents(contents: AnyObject, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        var data: NSData = contents as NSData
        var loadedModel: LearningPackModel = NSKeyedUnarchiver.unarchiveObjectWithData(data) as LearningPackModel
        
        self.id = loadedModel.id
        self.words = loadedModel.words
        self.corpus = loadedModel.corpus
        
        return true
    }
    
    override func contentsForType(typeName: String, error outError: NSErrorPointer) -> AnyObject? {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }

    // #MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.words, forKey: kLearingPackModelWords)
        aCoder.encodeObject(self.id, forKey: kLearingPackModelID)
        aCoder.encodeObject(self.corpus, forKey: kLearingPackModelCorpus)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.words = aDecoder.decodeObjectForKey(kLearingPackModelWords) as Array
        self.id = aDecoder.decodeObjectForKey(kLearingPackModelID) as String
        self.corpus = aDecoder.decodeObjectForKey(kLearingPackModelCorpus) as? String
        super.init(fileURL: DocumentHelper.cashURLForID(self.id))
    }
}
