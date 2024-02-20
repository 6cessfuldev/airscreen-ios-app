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
    
    var responseData: DepartingFlightsList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        print("FlightListViewController - viewDidLoad")
        getTest()
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
