//
//  FlightListViewController.swift
//  airscreen
//
//  Created by 육성민 on 2/17/24.
//

import Alamofire
import UIKit
import Foundation

class FlightListViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var terminalPopUpBtn: UIButton!
    @IBOutlet weak var counterPopUpBtn: UIButton!
    
    var responseData: DepartingFlightsList?
    
    let terminals: [String] = ["제1터미널", "제2터미널"]
    let counters: [String] = [
        "A",
        "B1",
        "B2",
        "C1",
        "C2",
        "D1",
        "D2",
        "E1",
        "E2",
        "F1",
        "F2",
        "G",
        "H1",
        "H2",
        "J1",
        "J2",
        "K1",
        "K2",
        "L1",
        "L2",
        "M1",
        "M2",
        "N"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        print("FlightListViewController - viewDidLoad")
        
        terminalPopUpBtn.menu = UIMenu(title: "터미널", children: terminals.map { item in
            UIAction(title: item) { (action) in
                print("Terminal : \(item)")
            }
        })
        
        counterPopUpBtn.menu =  UIMenu(title: "카운터", children:  counters.map { item in
            UIAction(title: item) { (action) in
                print("Counter : \(item)")
            }
        })

        
        getTest()
    }
    
    func function(selectedTerminal: String) {
      // Implement your logic here based on the selected terminal
      print("Selected terminal: \(selectedTerminal)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseData?.response.body.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        if let flight = responseData?.response.body.items?[indexPath.row] {
            cell.firstLabel.text = flight.airline
            cell.secondLabel.text = flight.airport
            cell.flightIdLabel.text = flight.flightId
        }
        
        return cell
    }
    
    func getTest() {
        let url = "http://apis.data.go.kr/B551177/StatusOfPassengerFlightsDeOdp/getPassengerDeparturesDeOdp"
        
        guard let serviceKey: String = Bundle.main.flightInfoListApiKey else {return}
        var request: Parameters = [
            "pageNo": 1,
            "numOfRows": 10,
            "type": "json",
            "searchday": DateFormatter().string(from: Date()),
            "inqtimechcd": "E",
            "serviceKey": serviceKey
        ]
        AF.request(url,
                   method: .get,
                   parameters: request,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate()
            .responseDecodable(of: DepartingFlightsList.self) { response in
                switch response.result {
                case .success(let DepartingFlightsList):
                    print("Received flightInfoList: \(DepartingFlightsList)")
                    self.responseData = DepartingFlightsList
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
        }
    }
    
}
