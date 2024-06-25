//
//  TypeaheadTableViewCell.swift
//  airscreen
//
//  Created by 육성민 on 6/21/24.
//

import Foundation
import UIKit

class TypeaheadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filghtid: UILabel!
    @IBOutlet weak var airline: UILabel!
    @IBOutlet weak var airport: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
