//
//  CustomNavigationBarView.swift
//  airscreen
//
//  Created by 육성민 on 2/17/24.
//

import UIKit

class CustomNavigationBarView: UINavigationBar {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.barTintColor = .darkestBlue
        self.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightestBlue
                ]
    }
}
