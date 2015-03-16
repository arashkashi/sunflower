//
//  BrowseTableViewCell.swift
//  Lafro
//
//  Created by Arash K. on 11/03/15.
//  Copyright (c) 2015 Arash K. All rights reserved.
//

import UIKit

protocol BrowseCellDelegate {
    func onCellResetTapped(indexPath: NSIndexPath)
    func onCellRemoveTapped(indexPath: NSIndexPath)
}

class BrowseTableViewCell: UITableViewCell {
    
    @IBOutlet var labelWordName: UILabel!
    @IBOutlet var labelProgress: UILabel!
    
    var word: Word!
    var delegate: BrowseCellDelegate!
    var indexPath: NSIndexPath!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithWord(word: Word, indexPath: NSIndexPath)
    {
        self.word = word
        self.indexPath = indexPath
        
        labelWordName.text = word.name
        labelProgress.text = "\(Int(word.learningProgress * 100))%"
    }
    
    @IBAction func onRemoveTapped(sender: AnyObject)
    {
        delegate.onCellRemoveTapped(indexPath)
    }
    
    @IBAction func onResetTapped(sender: AnyObject)
    {
        delegate.onCellResetTapped(indexPath)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
