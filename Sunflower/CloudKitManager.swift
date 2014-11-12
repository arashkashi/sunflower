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
    var userRecordID: CKRecordID? {
        get {
            var recordDict = NSUserDefaults.standardUserDefaults().objectForKey(kCloudManagerRecordID) as? Dictionary<String, String>
            if recordDict != nil {
                return self.userRecordIDFromDict(recordDict!)
            } else {
                self.fetchUserRecordID(nil)
                return nil
            }
        }
        
        set {
            if newValue == nil { self.userRecordID = nil } else {
                var userRecordIDDict = self.dictFromUserRecordID(newValue!)
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: kCloudManagerRecordID)
                self.userRecordID = newValue
            }
        }
    }
    
    func fetchUserRecord(handler: (record: CKRecord?, err: NSError!)->() ) {
        if userRecordID == nil { handler(record: nil, err: NSError(domain: "Missing Record ID", code: 69, userInfo: nil))}
        
        CKContainer.defaultContainer().publicCloudDatabase.fetchRecordWithID(userRecordID, completionHandler: { (userRecord: CKRecord!, err: NSError!) -> Void in
            handler(record: userRecord, err: err)
        })
    }
    
    func updateUserRecord(userRecord: CKRecord, handler: (CKRecord!, NSError!) -> Void ) {
        CKContainer.defaultContainer().publicCloudDatabase.saveRecord(userRecord, completionHandler: handler)
    }
    
    func fetchUserRecordID(handler:((recordID: CKRecordID!, err: NSError!) -> Void)?) {
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler({ (recordID: CKRecordID!, err: NSError!) -> Void in
            handler?(recordID: recordID, err: err)
            if recordID != nil && err == nil {
                self.userRecordID = recordID
            } else {
                // User not authenticated to iCloud
                if (err.code == 9) {
                    print(err.localizedDescription)
                }
            }
        })
    }
    
    // MARK: Initiation
    class var sharedInstance : CloudKitManager {
        struct Static {
            static let instance : CloudKitManager = CloudKitManager()
        }
        return Static.instance
    }
    
    init() {
    }
    
    // MARK: Helper
    func userRecordIDFromDict(dict: Dictionary<String, String>) -> CKRecordID {
        var recordName = dict["recordName"]
        var zoneName = dict["zoneName"]
        var ownerName = dict["ownerName"]
        
        var recordZoneID = CKRecordZoneID(zoneName: zoneName, ownerName: ownerName)
        return CKRecordID(recordName: recordName, zoneID: recordZoneID)
    }
    
    func dictFromUserRecordID(record: CKRecordID) -> Dictionary<String, String> {
        var result = Dictionary<String, String>()
        result["recordName"] = record.recordName
        result["zoneName"] = record.zoneID.zoneName
        result["ownerName"] = record.zoneID.ownerName
        return result
    }
}
