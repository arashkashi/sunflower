//
//  WordPresentationViewController.swift
//  Sunflower
//
//  Created by Arash K. on 27/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

protocol WordPresentationViewControllerDelegate
{
    func onWordDictationMeaningEdited(word: Word)
    func onWordNewSentenceAdded(word: Word)
}

class WordPresentationViewController: UIViewController {
    
    @IBOutlet var labelWord: UILabel!
    @IBOutlet var labelMeaning: UILabel!
    
    var completionHandler: (() -> ())?
    var word : Word?
    
    var delegate: WordPresentationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelWord.text = self.word!.name
        self.labelMeaning.text = self.word!.meaning
    }
    
    // MARK: view Manipulation
    func updateView(animated: Bool) {
        self.labelWord.text = self.word?.name
        self.labelMeaning.text = self.word?.meaning
        
        if animated {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.labelWord.alpha = 1.0
                self.labelMeaning.alpha = 1.0
            })
        } else {
            self.labelWord.alpha = 1.0
            self.labelMeaning.alpha = 1.0
        }
    }
    
    // MARK: IB Actions
    @IBAction func onEditButtonTapped(sender: UIButton) {
        askUserWhatToDo { (whatToDo: String) -> Void in
            if whatToDo == "editWord" {
                self.onEditButtonTapped()
            } else {
                self.onAddNewSentenceTapped()
            }
        }
        
        onEditButtonTapped()
    }
    
    func askUserWhatToDo( handler: (String)-> Void ) {
        var alertStyle: UIAlertControllerStyle = .ActionSheet
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            alertStyle = .Alert
        }
        
        var alertController = UIAlertController(title: nil, message: nil, preferredStyle:alertStyle)
        
        var editWordMeaningAction = UIAlertAction(title: "Edit word's meaning/dictation?", style: .Destructive) { (action: UIAlertAction!) -> Void in
            handler("editWord")
            return
        }
        
        var addSentenceAction = UIAlertAction(title: "Add a new sample sentence?", style: .Destructive) { (action: UIAlertAction!) -> Void in
            handler("addsentence")
            return
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) -> Void in
            self.updateView(false)
        }
        
        alertController.addAction(editWordMeaningAction)
        alertController.addAction(addSentenceAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
    func onAddNewSentenceTapped() {
        self.labelWord.alpha = 0
        self.labelMeaning.alpha = 0
        
        var alertController =  UIAlertController(title: "Editting", message: "Enter the new sentence.", preferredStyle: .Alert )
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.autocorrectionType = .Yes
        }
        
        var addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            var nameTextfield = alertController.textFields?.first as! UITextField
            
            self.word?.sentences.append(Sentence(original: nameTextfield.text, translated: ""))
            
            self.updateView(true)
            
            self.delegate?.onWordNewSentenceAdded(self.word!)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            
            self.updateView(false)
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
    func onEditButtonTapped() {
        
        self.labelWord.alpha = 0
        self.labelMeaning.alpha = 0
        
        var alertController =  UIAlertController(title: "Editting", message: "Enter editted word and its editted meaning.", preferredStyle: .Alert )
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = self.word?.name
            textField.autocorrectionType = .Yes
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = self.word?.meaning
            textField.autocorrectionType = .Yes
        }
        
        var skipAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            var nameTextfield = alertController.textFields?.first as! UITextField
            var meaningTextField = alertController.textFields?.last as! UITextField
            
            self.word?.name = nameTextfield.text
            self.word?.meaning = meaningTextField.text
            
            self.updateView(true)
            
            self.delegate?.onWordDictationMeaningEdited(self.word!)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            self.updateView(false)
        }
        
        alertController.addAction(skipAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
}
