//
//  PresentTableViewCell.swift
//  PresentBase
//
//  Created by Zabeehullah Qayumi on 9/12/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import UIKit

class PresentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
