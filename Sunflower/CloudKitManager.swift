//
//  CloudKitManager.swift
//  Sunflower
//
//  Created by ArashHome on 11/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation
import CloudKit

let kCloudManagerRecordID = "kCloudManagerRecordID"

class CloudKitManager {

    func fetchUserRecord(handler: (record: CKRecord?, err: NSError!)->() ) {
        self.fetchUserRecordID { (recordID, err) -> Void in
            
            if recordID == nil { handler(record: nil, err: nil); return }
            
            CKContainer.defaultContainer().publicCloudDatabase.fetchRecordWithID(recordID, completionHandler: { (record: CKRecord!, error: NSError!) -> Void in
                    handler(record: record, err: nil); return
            })
        }
    }
    
    func fetchUserRecordID(handler:(recdID: CKRecordID!, err: NSError!) -> Void) {
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler({ (recordID: CKRecordID!, error: NSError!) -> Void in
            handler(recdID: recordID, err: error)
            // Error code 9: user not authenticated to iCloud
        })
    }
    
    func saveRecord(updatedRecord: CKRecord, handler: (CKRecord!, NSError!) -> Void ) {
        CKContainer.defaultContainer().publicCloudDatabase.saveRecord(updatedRecord, completionHandler: handler)
    }
    
    // MARK: Initiation
    class var sharedInstance : CloudKitManager {
        struct Static {
            static let instance : CloudKitManager = CloudKitManager()
        }
        return Static.instance
    }
}
