//
//  MakePackageViewController.swift
//  Sunflower
//
//  Created by Arash Kashi on 05/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

class MakePackageViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var buttonDo: UIBarButtonItem!
    @IBOutlet var textFieldBundleID: UITextField!
    @IBOutlet var textViewCorpus: UITextView!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func onDoTapped(sender: UIBarButtonItem) {
        // Return if info is not there
        if textViewCorpus.text == "" || textFieldBundleID.text == "" { return }
        
        // Tokenize the corpus
        var tokens: [String] = Parser.sortedUniqueTokensFor(self.textViewCorpus.text)
        tokens = tokens.filter{$0 != ""}
        
        // Translate each token and make words
        var words: [Word] = []
        for token in tokens {
            GoogleTranslate.sharedInstance.translate(token, completionHandler: { (translation) -> () in
                var word = Word(name: token, meaning: translation!, sentences: [])
                words.append(word)
                
                if words.count == tokens.count {
                    self.onTranslationFinished(words)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        textViewCorpus.text = " Nach der Schlappe der Demokraten von Präsident Obama bei den US-Kongresswahlen können die Republikaner nun die politische Agenda maßgeblich beeinflussen. Doch zwei Jahre Blockade können sie sich nicht leisten"
    }
    
    func onTranslationFinished(words: [Word]) {
        LearningPackPersController.sharedInstance.addNewPackage(textFieldBundleID.text, words: words)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navigationController() -> UINavigationController {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.rootNavigationController!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
