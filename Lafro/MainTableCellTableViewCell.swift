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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var labelrightIndicator: UILabel!
    @IBOutlet var labelProgressCircular: KAProgressLabel!

    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        showLoadingContent()
        self.backgroundColor = UIColor.blackColor()
        
        labelProgressCircular.fillColor = UIColor.clearColor()
        labelProgressCircular.trackColor = UIColor(red: 51.0/255.0, green: 0.0, blue: 0.0, alpha: 1)
        labelProgressCircular.progressColor = UIColor(red: 252.0/255.0, green: 6.0/255.0, blue: 0.0, alpha: 1)

        labelProgressCircular.textColor = UIColor.whiteColor()
        labelProgressCircular.font = UIFont(name: "Helvetica-Bold", size: 10)
        
        labelProgressCircular.trackWidth = 6.0
        labelProgressCircular.progressWidth = 6.0
        labelProgressCircular.roundedCornersWidth = 6.0
    }
    
    override func prepareForReuse() {
        labelProgressCircular.progress = 0.0
    }
    
    // MARK: View manipulation (API)
    func updateWithLearningPackModel(learningPackModel: LearningPackModel) {
        labelProgressCircular.progress = 0.0
        
        id = learningPackModel.id
        var wordsDueInFuture = learningPackModel.wordsDueInFuture()
        var allWords = learningPackModel.words
        var proportion = CGFloat(wordsDueInFuture.count)/CGFloat(allWords.count)
        
        labelID.text = "\(learningPackModel.id)"
        
        labelProgressCircular.text = "\(allWords.count)"
        
        if Int(learningPackModel.progress) > 80 {
            labelProgressCircular.textColor = UIColor.greenColor()
        } else {
            labelProgressCircular.textColor = UIColor.orangeColor()
        }
        
        activityIndicator.hidden = true
        labelrightIndicator.hidden = false
        self.showContent(false)
        
        labelProgressCircular.setProgress(proportion, timing: TPPropertyAnimationTimingLinear, duration: 1, delay: 1)
    }
    
    func showContent(animated: Bool) {
        backgroundColor = UIColor.blackColor()
        labelProgressCircular.hidden = false
        
        if animated {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.labelID.alpha = 1
                self.labelProgressCircular.alpha = 1
            })
        } else {
            labelID.alpha = 1
            labelProgressCircular.alpha = 1
        }
    }
    
    func showLoadingContent() {
        labelID.alpha = 0
        labelProgressCircular.alpha = 0
        labelProgressCircular.progress = 0.0
        labelrightIndicator.hidden = true
        activityIndicator.hidden = false
        backgroundColor = UIColor.blackColor()
    }
    
    func showMergingContent() {
        showLoadingContent()
        activityIndicator.hidden = true
        backgroundColor = UIColor.redColor()
        labelProgressCircular.hidden = true
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
