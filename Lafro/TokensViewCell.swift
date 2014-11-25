//
//  TokensCellViewTableViewCell.swift
//  Sunflower
//
//  Created by ArashHome on 20/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class TokensViewCell: UITableViewCell {
    var token: String!
    var isSelected: Bool!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCellWith(token: String) {
        self.token = token
        self.textLabel.text = token
        self.detailTextLabel!.text = "L$: \(GoogleTranslate.sharedInstance.costToTranslate(token))"
        isSelected = false
    }
    
    func onSelected() {
        isSelected = true
        self.textLabel.text = "(√) \(token)"
        
    }
    
    func onDeslected() {
        isSelected = false
        self.textLabel.text = "(x) \(token)"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
