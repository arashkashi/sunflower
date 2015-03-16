//
//  MainTableCellTableViewCell.swift
//  Sunflower
//
//  Created by Arash K. on 29/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class MainTableCellView: SWTableViewCell {
    
    var id: String!

    @IBOutlet var labelID: UILabel!
    @IBOutlet var labelProgress: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var labelrightIndicator: UILabel!
    @IBOutlet weak var labelProgressProportion: UILabel!

    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        showLoadingContent()
        self.backgroundColor = UIColor.blackColor()
    }
    
    // MARK: View manipulation (API)
    func updateWithLearningPackModel(learningPackModel: LearningPackModel) {
        id = learningPackModel.id
        var wordsDueInFuture = learningPackModel.wordsDueInFuture()
        var allWords = learningPackModel.words
        var proportion = "\(wordsDueInFuture.count)/\(allWords.count)"
        
        labelProgressProportion.text = "\(proportion)"
        labelID.text = "\(learningPackModel.id)"
        labelProgress.text = "\(Int(learningPackModel.progress))%"
        
        if Int(learningPackModel.progress) > 80 {
            labelProgress.textColor = UIColor.greenColor()
        } else {
            labelProgress.textColor = UIColor.yellowColor   ()
        }
        
        activityIndicator.hidden = true
        labelrightIndicator.hidden = false
        self.showContent(true)
    }
    
    func showContent(animated: Bool) {
        backgroundColor = UIColor.blackColor()
        labelProgressProportion.hidden = false
        
        if animated {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.labelID.alpha = 1
                self.labelProgress.alpha = 1
            })
        } else {
            labelID.alpha = 1
            labelProgress.alpha = 1
        }
    }
    
    func showLoadingContent() {
        labelID.alpha = 0
        labelProgress.alpha = 0
        labelrightIndicator.hidden = true
        activityIndicator.hidden = false
        backgroundColor = UIColor.blackColor()
    }
    
    func showMergingContent() {
        showLoadingContent()
        activityIndicator.hidden = true
        backgroundColor = UIColor.redColor()
        labelProgressProportion.hidden = true
        hideUtilityButtonsAnimated(false)
    }
    
    // MARK: Helper
    func cellhasLoaded() -> Bool {
        return id != nil
    }

    // MARK: Delegate
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
