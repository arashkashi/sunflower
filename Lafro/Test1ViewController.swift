//
//  Test1ViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/08/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

protocol Test1Delegate {
    func onAnswerSelected()
}

class Test1ViewController : TestBaseViewController {
    
    var wordChoices: [Word] = []
    var buttonsBGColor: UIColor = UIColor.whiteColor()
    var selectedAnswer: String?

    @IBOutlet var buttonsChoices: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButtonChoicesWith(self.wordChoices)
        
        // Back up the background color
        self.buttonsBGColor = self.buttonsChoices![0].backgroundColor!
    }
    
    func updateButtonChoicesWith(words: [Word]) {
        for (index, button) in enumerate(self.buttonsChoices) {
            button.setTitle(words[index].meaning, forState: .Normal)
        }
    }

    // MARK: IBAction
    @IBAction func onChoiceSelected(sender: AnyObject) {
        var tappedButton = sender as UIButton
        
        self.selectedAnswer = tappedButton.titleLabel?.text
        
        self.highlightButton(tappedButton)
        self.delegate?.onAsnwerSelected()
    }
    
    // MARK: Logic
    override func checkAnswer(completionHandler:(()->())?) {
        disableButtons()
        if selectedAnswer != nil {
            if selectedAnswer! == word?.meaning {
                resultViewController.showCorrect(true, completionHandler: completionHandler)
                self.completionHandler?(test!, .Pass, word!)
            } else {
                resultViewController.showWrong(true, completionHandler: completionHandler)
                self.completionHandler?(test!, .Fail, word!)
            }
        }
    }
    
    // MARK: Helper
    func highlightButton(button: UIButton) {
        self.removeHighlight(self.buttonsChoices)
        button.backgroundColor = UIColor.whiteColor()
    }
    
    func disableButtons() {
        for button in buttonsChoices {
            button.enabled = false
        }
    }
    
    func removeHighlight(buttons: [UIButton]) {
        for button in buttons {
            button.backgroundColor = self.buttonsBGColor
        }
    }
}
