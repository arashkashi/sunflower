//
//  PresentationViewController.swift
//  Sunflower
//
//  Created by Arash K. on 28/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class PresentationViewController : UIViewController {
    
    @IBOutlet var labelWord: UILabel!
    var completionHandler: (() -> ())?
    var word : Word?
    
    @IBAction func onOkTapped(sender: AnyObject) {
        self.completionHandler?()
    }
    
    override func viewDidLoad() {
        self.labelWord.text = self.word!.name
    }
}
