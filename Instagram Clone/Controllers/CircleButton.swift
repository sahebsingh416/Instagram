//
//  CircleButton.swift
//  Instagram Clone
//
//  Created by Saheb Singh Tuteja on 05/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    let image : UIImage = Reusable.shared.getImage()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        setButtonStyle()
    }
    
    func setButtonStyle(){
        self.layer.cornerRadius = self.layer.bounds.size.width / 2
        self.layer.borderWidth = 1
        image.
        self.setImage(image, for: .normal)
    }
}
