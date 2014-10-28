//
//  SampleSentenceViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class SampleSentenceViewController: UIViewController {
    
    var word: Word?
    var index: Int?

    @IBOutlet var labelOriginalLanguage: UILabel!
    @IBOutlet var labelTranslated: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelOriginalLanguage.text = word?.sentences[index!].original
        self.labelTranslated.text = word?.sentences[index!].translated
    }
}
