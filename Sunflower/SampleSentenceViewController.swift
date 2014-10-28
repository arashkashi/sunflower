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
        
        self.labelOriginalLanguage.alpha = 0
        self.labelTranslated.alpha = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        self.changeLabelAlphaWithAnimation(1)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.changeLabelAlphaWithAnimation(0)
    }
    
    func changeLabelAlphaWithAnimation(newAlpha: CGFloat) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.labelOriginalLanguage.alpha = newAlpha
            }) { (success: Bool) -> Void in
                UIView.animateWithDuration(1, animations: { () -> Void in
                    self.labelTranslated.alpha = newAlpha
                })
        }
    }
}
