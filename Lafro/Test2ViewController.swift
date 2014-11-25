//
//  Test2ViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class Test2ViewController : Test1ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButtonChoicesWith(self.wordChoices)
        
        // Back up the background color
        self.buttonsBGColor = self.buttonsChoices![0].backgroundColor!
        
        self.wordLabel!.text = self.word!.meaning
    }
    
    override func updateButtonChoicesWith(words: [Word]) {
        for (index, button) in enumerate(self.buttonsChoices) {
            button.setTitle(words[index].name, forState: .Normal)
        }
    }
    
    // MARK: Logic
    override func checkAnswer(completionHandler:(()->())?) {
        disableButtons()
        if selectedAnswer != nil {
            if selectedAnswer! == word?.name {
                resultViewController.showCorrect(true
                    , completionHandler: completionHandler)
                self.completionHandler?(test!, .Pass, word!)
            } else {
                resultViewController.showWrong(true
                    , completionHandler: completionHandler)
                self.completionHandler?(test!, .Fail, word!)
            }
        }
    }


}
