//
//  UIAlertHelper.swift
//  Lafro
//
//  Created by Arash K. on 04/03/15.
//  Copyright (c) 2015 Arash K. All rights reserved.
//

import Foundation
import UIKit

class UIAlertHelper {
    
    class func showConfirmationForMerging(viewController: UIViewController, id_1: String, id_2: String, yesAction: ((UIAlertAction!)-> Void)!, noAction: ((UIAlertAction!)-> Void)!) {
        let alertController = UIAlertController(title: "Merge", message: "Are you sure you want to merge \(id_2) with \(id_1)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Yes", style: .Destructive, handler: yesAction)
        let noAction = UIAlertAction(title: "No", style: .Destructive, handler: noAction)
        
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func showErrorWhenSamePackgeSelectedForMerging(viewController: UIViewController, id: String, cancelMerge: ((UIAlertAction!)-> Void)!) {
        let alertController = UIAlertController(title: "Error", message: "You can not merge a package with itself", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Cancel Merge", style: .Destructive, handler: cancelMerge)
        
        let yesAction = UIAlertAction(title: "Continue Merge", style: .Default) { (action) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(yesAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
}
