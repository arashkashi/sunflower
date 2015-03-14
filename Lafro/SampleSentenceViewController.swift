//
//  SampleSentenceViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

protocol SampleSentenceViewControllerDelegate {
    func onSentenceEditted(index: Int, word: Word, isSentenceRemoved: Bool)
}

class SampleSentenceViewController: CorpusViewController {
    
    var index: Int!
    var delegate: SampleSentenceViewControllerDelegate?
    
    override func viewDidLoad() {
        self.fontSize = 32
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {

    }
    @IBAction func onEditTapped(sender: UIButton) {
        onEditButtonTapped()
    }
    
    // MARK: view Manipulation
    func updateViewWithContent() {
        super.updateViewWith(self.word!)
        self.textViewCorpus.alpha = 1.0
    }

    func onEditButtonTapped() {
        
        self.textViewCorpus.alpha = 0
        
        var alertController =  UIAlertController(title: "Editting", message: "Enter editted sentence.", preferredStyle: .Alert )
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = self.word!.sentences[self.index].original
            textField.autocorrectionType = .Yes
        }
        
        var skipAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            var sentence = (alertController.textFields?.first as UITextField).text as String
            
            
            if sentence == "" {
                self.word!.sentences.removeAtIndex(self.index)
                self.delegate?.onSentenceEditted(self.index, word: self.word!, isSentenceRemoved: true)
                
            } else {
                self.word!.sentences[self.index] = Sentence(original: sentence, translated: "")
                self.delegate?.onSentenceEditted(self.index, word: self.word!, isSentenceRemoved: false)
            }
            
            self.updateViewWithContent()
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            self.updateViewWithContent()
        }
        
        alertController.addAction(skipAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
}
