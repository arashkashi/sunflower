//
//  CorpusViewController.swift
//  Sunflower
//
//  Created by Arash K. on 09/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class CorpusViewController: UIViewController {
    
    var corpus: String?
    var word: Word?
    var textStorage: TKDHighlightingTextStorage!
    var fontSize: Int?

    @IBOutlet var textViewCorpus: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fontSize == nil {
            fontSize = 16
        }

        if let selectedWord = word {
            self.updateViewWith(selectedWord)
        } else {
            self.textViewCorpus.text = corpus
        }
    }
    
    func updateViewWith(selectedWord: Word) {
        textStorage = TKDHighlightingTextStorage()
        textStorage.fontSize = fontSize!
        textStorage.regularExpression = NSRegularExpression(pattern: selectedWord.name, options: .allZeros, error: nil)
        textStorage.addLayoutManager(self.textViewCorpus.layoutManager)
        textStorage.replaceCharactersInRange(NSRange(location: 0,length: 0), withString: corpus!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        textStorage = nil
    }
    
    deinit {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
