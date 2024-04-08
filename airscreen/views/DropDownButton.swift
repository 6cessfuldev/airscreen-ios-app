//
//  DropDownButton.swift
//  airscreen
//
//  Created by 육성민 on 4/8/24.
//

import UIKit

class DropDownButton : UIButton {
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.lightestBlue
        self.layer.borderColor = UIColor.mainBlue.cgColor
        self.layer.borderWidth = 1.0
    }
}
