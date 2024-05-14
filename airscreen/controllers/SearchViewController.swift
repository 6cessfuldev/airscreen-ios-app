//
//  SearchViewController.swift
//  airscreen
//
//  Created by 육성민 on 2/17/24.
//

import Foundation
import UIKit
import Alamofire

class SearchViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func searchBtnAction(_ sender: Any) {
        guard let keyword = textField.text else {return}
        getFlightsList(keyword: keyword);
    }
    
    var responseData: [FlightItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchViewController - viewDidLoad")
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBtn.layer.masksToBounds = true
        searchBtn.layer.cornerRadius = 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        if let flight = responseData?[indexPath.row] {
            
            cell.scheduleTimeLabel.text = convertDateFormat(rawDate: flight.scheduleDateTime)
            cell.changedTimeLabel.text = convertDateFormat(rawDate: flight.estimatedDateTime)
            cell.flightIdLabel.text = flight.flightId
            cell.airportLabel.text = flight.airport
            cell.counterLabel.text = flight.chkinrange
            cell.gateLabel.text = flight.gatenumber
            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(white: 1.0, alpha: 0.6) : UIColor.lightestBlue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedDatas = self.responseData else { return }
        let selectedData = selectedDatas[indexPath.row]
        
        if let flightInfoViewController = self.storyboard?.instantiateViewController(identifier: "FlightInfoViewController") as? FlightInfoViewController {
                flightInfoViewController.flightData = selectedData
                present(flightInfoViewController, animated: true, completion: nil)
            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.lightestBlue

        let firstLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width*0.15, height: 30))
        firstLabel.text = "출발 시간"
        firstLabel.font = UIFont.systemFont(ofSize: 12)
        firstLabel.textColor = UIColor.mainBlue
        firstLabel.textAlignment = NSTextAlignment.center
        headerView.addSubview(firstLabel)
        
        let secondLabel = UILabel(frame: CGRect(x: tableView.frame.width*0.15, y: 0, width: tableView.frame.width*0.3, height: 30))
        secondLabel.text = "편명"
        secondLabel.font = UIFont.systemFont(ofSize: 12)
        secondLabel.textColor = UIColor.mainBlue
        secondLabel.textAlignment = NSTextAlignment.center
        headerView.addSubview(secondLabel)
        
        let thirdLabel = UILabel(frame: CGRect(x: tableView.frame.width*0.45, y: 0, width: tableView.frame.width*0.3, height: 30))
        thirdLabel.text = "도착지・경유지"
        thirdLabel.font = UIFont.systemFont(ofSize: 12)
        thirdLabel.textColor = UIColor.mainBlue
        thirdLabel.textAlignment = NSTextAlignment.center
        headerView.addSubview(thirdLabel)
        
        let fourthLabel = UILabel(frame: CGRect(x: tableView.frame.width*0.75, y: 0, width: tableView.frame.width*0.25, height: 30))
        fourthLabel.text = "체크인・게이트"
        fourthLabel.font = UIFont.systemFont(ofSize: 12)
        fourthLabel.textColor = UIColor.mainBlue
        fourthLabel.textAlignment = NSTextAlignment.center
        headerView.addSubview(fourthLabel)

        return headerView
    }
    
    func getFlightsList(keyword : String) {
        let url = "http://apis.data.go.kr/B551177/StatusOfPassengerFlightsDeOdp/getPassengerDeparturesDeOdp"
        guard let serviceKey: String = Bundle.main.flightInfoListApiKey else {return}
        let request: Parameters = [
            "pageNo": 1,
            "numOfRows": 4000,
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
            .responseDecodable(of: APIResponse<DepartingFlightsList>.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    self.responseData = apiResponse.response.body.items?.filter{
                        (item) -> Bool in
                        if let flightId = item.flightId {
                            return flightId.contains(keyword.uppercased())
                        } else {
                            return false
                        }
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
        }
    }
    
    func convertDateFormat(rawDate: String?) -> String {
        guard let rawDate = rawDate, !rawDate.isEmpty else { return "" }

        var startIndex = rawDate.index(rawDate.startIndex, offsetBy: 8)
        var endIndex = rawDate.index(startIndex, offsetBy: 2)
        let date = rawDate[startIndex..<endIndex]
        startIndex = rawDate.index(rawDate.startIndex, offsetBy: 10)
        endIndex = rawDate.index(startIndex, offsetBy: 2)
        let time = rawDate[startIndex..<endIndex]

      return "\(date):\(time)"
    }
}
