//
//  WordPresentationViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class WordPresentationViewController: UIViewController {
    
    @IBOutlet var labelWord: UILabel!
    @IBOutlet var labelMeaning: UILabel!
    
    var completionHandler: (() -> ())?
    var word : Word?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelWord.text = self.word!.name
        self.labelMeaning.text = self.word!.meaning
    }
    
}
