//
//  TokensCellViewTableViewCell.swift
//  Sunflower
//
//  Created by ArashHome on 20/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit

class TokensViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCellWith(token: String) {
        self.textLabel.text = token
        self.detailTextLabel!.text = "Cost: \(GoogleTranslate.sharedInstance.costToTranslate(token))"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
