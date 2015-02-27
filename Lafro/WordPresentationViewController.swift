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
    func onWordEdited(word: Word)
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
        onEditButtonTapped()
    }
    // MARK: Edit View
    func onEditButtonTapped() {
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.labelWord.alpha = 0
            self.labelMeaning.alpha = 0
        })
        
        var alertController =  UIAlertController(title: "Editting", message: "Enter word and its meaning.", preferredStyle: .Alert )
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = self.word?.name
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.text = self.word?.meaning
        }
        
        var skipAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            var nameTextfield = alertController.textFields?.first as UITextField
            var meaningTextField = alertController.textFields?.last as UITextField
            
            self.word?.name = nameTextfield.text
            self.word?.meaning = meaningTextField.text
            
            self.updateView(true)
            
            self.delegate?.onWordEdited(self.word!)
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action: UIAlertAction!) -> Void in
            self.updateView(true)
        }

        alertController.addAction(skipAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true) { () -> Void in
            //
        }
    }
    
}
