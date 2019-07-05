//
//  Rounded Image.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 05/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class Rounded_Image: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        setImageStyle()
    }
    
    func setImageStyle(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.image = Reusable.shared.getImage()
    }
}
