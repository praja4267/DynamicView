//
//  LabelTableViewCell.swift
//  DynamicView
//
//  Created by Active Mac05 on 21/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet var labelForTVCell: UILabel!
    
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
