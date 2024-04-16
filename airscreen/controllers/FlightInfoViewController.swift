//
//  FlightInfoViewController.swift
//  airscreen
//
//  Created by 육성민 on 4/8/24.
//

import UIKit

class FlightInfoViewController : UIViewController {
    
    @IBOutlet weak var airline: UILabel!
    @IBOutlet weak var flightId: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var gate: UILabel!
    @IBOutlet weak var terminal: UILabel!
    @IBOutlet weak var airport: UILabel!
    
    var flightData: FlightItem?
    
    override func viewDidLoad() {
        print("FlightInfoViewController - viewDidLoad")
        
        if let data = flightData {
            airline.text = data.airline
            flightId.text = data.flightId
            date.text = data.estimatedDateTime
            airport.text = data.airport
            counter.text = data.chkinrange
            gate.text = data.gatenumber
            terminal.text = data.terminalid
        }
    }
    
}
