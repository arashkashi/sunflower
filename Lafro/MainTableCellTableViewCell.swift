//
//  MainTableCellTableViewCell.swift
//  Sunflower
//
//  Created by Arash K. on 29/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

protocol MainViewCellDelegate {
    func onCellTapped(sender: UITableViewCell)
}

class MainTableCellView: UITableViewCell {
    
    var delegate: MainViewCellDelegate?
    var id: String!

    @IBOutlet var labelID: UILabel!
    @IBOutlet var labelProgress: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var labelrightIndicator: UILabel!
    
    // MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.showLoadingContent()
        addGestureRecognizer()
        self.backgroundColor = UIColor.blackColor()
    }
    
    func addGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        self.addGestureRecognizer(recognizer)
    }
    
    // MARK: User Interaction Logic
    func handleTap(recognizer: UITapGestureRecognizer) {
        self.delegate?.onCellTapped(self)
    }
    
    func updateWithLearningPackModel(learningPackModel: LearningPackModel) {
        id = learningPackModel.id
        var wordsDueInFuture = learningPackModel.wordsDueInFuture()
        var allWords = learningPackModel.words
        var proportion = "\(wordsDueInFuture.count)/\(allWords.count)"
        
        labelID.text = "\(learningPackModel.id) \t  \(proportion) "
        labelProgress.text = "\(Int(learningPackModel.progress))%"
        
        activityIndicator.hidden = true
        labelrightIndicator.hidden = false
        self.showContent(true)
    }
    
    // MARK: View manipulation
    func showContent(animated: Bool) {
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
    }

    // MARK: Delegate
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Helper
    func button(title: String, color: UIColor, selector: String, order: Int, numberOfButtons: Int) -> UIButton {
        var buttonFrame = frameForButton(order, numberOfButtons: numberOfButtons)
        var button = UIButton(frame: buttonFrame)
        
        button.backgroundColor = color
        button.addTarget(self, action:Selector(selector), forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func frameForButton(order: Int, numberOfButtons: Int) -> CGRect {
        var height = self.frame.size.height
        var width = CGFloat(self.frame.size.width) / CGFloat(numberOfButtons)
        return CGRect(x: CGFloat(order) * width, y: 0.0, width: width, height: height)
    }
}
