//
//  ProfileCell.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 03/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
