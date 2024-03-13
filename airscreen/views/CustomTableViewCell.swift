//
//  CustomTableViewCell.swift
//  airscreen
//
//  Created by 육성민 on 2/20/24.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var changedTimeLabel: UILabel!
    @IBOutlet weak var flightIdLabel: UILabel!
    @IBOutlet weak var airportLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var gateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
