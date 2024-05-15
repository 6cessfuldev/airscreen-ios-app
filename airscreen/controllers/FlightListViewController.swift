//
//  FlightListViewController.swift
//  airscreen
//
//  Created by 육성민 on 2/17/24.
//

import Alamofire
import UIKit
import Foundation

class FlightListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var terminalPopUpBtn: UIButton!
    @IBOutlet weak var counterPopUpBtn: UIButton!
    @IBOutlet weak var lastUpdateDate: UILabel!
    
    var responseData: [FlightItem]?
    var filteredData: [FlightItem] = []
    
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
        tableView.delegate = self
        print("FlightListViewController - viewDidLoad")
        
        terminalPopUpBtn.menu = UIMenu(title: "터미널", children: terminals.map { item in
            UIAction(title: item) { (action) in
                self.filterData(terminal: action.title, counter: self.counterPopUpBtn.titleLabel!.text!)
                self.tableView.reloadData()
            }
        })
        
        counterPopUpBtn.menu =  UIMenu(title: "카운터", children:  counters.map { item in
            UIAction(title: item) { (action) in
                self.filterData(terminal: self.terminalPopUpBtn.titleLabel!.text!, counter: action.title)
                self.tableView.reloadData()
            }
        })
        
        getFlightsList()
    }
    
    func function(selectedTerminal: String) {
      // Implement your logic here based on the selected terminal
      print("Selected terminal: \(selectedTerminal)")
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 // 필요한 높이에 따라 조절
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let flight = filteredData[indexPath.row]
        cell.scheduleTimeLabel.text = convertDateFormat(rawDate: flight.scheduleDateTime)
        cell.changedTimeLabel.text = convertDateFormat(rawDate: flight.estimatedDateTime)
        cell.flightIdLabel.text = flight.flightId
        cell.airportLabel.text = flight.airport
        cell.counterLabel.text = flight.chkinrange
        cell.gateLabel.text = flight.gatenumber
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor(white: 1.0, alpha: 0.6) : UIColor.lightestBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedData = self.filteredData[indexPath.row]
        
        if let flightInfoViewController = self.storyboard?.instantiateViewController(identifier: "FlightInfoViewController") as? FlightInfoViewController {
                flightInfoViewController.flightData = selectedData
                present(flightInfoViewController, animated: true, completion: nil)
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
    
    func getFlightsList() {
        let url = "http://apis.data.go.kr/B551177/StatusOfPassengerFlightsDeOdp/getPassengerDeparturesDeOdp"
        guard let serviceKey: String = Bundle.main.flightInfoListApiKey else {return}
        let request: Parameters = [
            "pageNo": 1,
            "numOfRows": 4000,
            "type": "json",
            "searchday": DateFormatter().string(from: Date()),
            "inqtimechcd": "E",
            "serviceKey": serviceKey,
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
                    print("Received flightInfoList: \(apiResponse)")
                    self.responseData = apiResponse.response.body.items
                    self.filterData(terminal: self.terminalPopUpBtn.titleLabel!.text!, counter: self.counterPopUpBtn.titleLabel!.text!)
                    self.tableView.reloadData()
                    
                    let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                    self.lastUpdateDate.text = dateFormatter.string(from: Date())
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
        }
    }
    
    func filterData(terminal : String, counter : String) {
        guard let responseData = self.responseData else {return}
        self.filteredData =  responseData.filter { item in
            
            // terminal filter
            guard let terminalid = item.terminalid else {return false}
            switch terminal {
                case "제1터미널":
                if !(["P01", "P02"].contains(terminalid)) {
                    return false
                }
                case "제2터미널":
                if (terminalid != "P03") {
                    return false
                }
            default:
                return false
            }

            if let chkinrange = item.chkinrange, chkinrange.contains("-"), chkinrange.count >= 7 {
                
                guard let firstCharUnicode = chkinrange.unicodeScalars.first?.value,
                      let lastCharUnicode = chkinrange.unicodeScalars.dropFirst(4).first?.value
                       else {return false}
                
                let firstCodeSubstring = chkinrange.dropFirst().prefix(2)
                guard let firstCode = Int(firstCodeSubstring) else {return false}
                
                let lastCodeSubstring = chkinrange.dropFirst(5).prefix(2)
                guard let lastCode = Int(lastCodeSubstring) else {return false}

                let selectChkChar = counter.unicodeScalars.first?.value ?? 0
                let selectChkNum = counter.count > 1 ? Int(String(counter[counter.index(counter.startIndex, offsetBy: 1)])) : nil

                if selectChkChar < firstCharUnicode || selectChkChar > lastCharUnicode {
                    return false
                }

                if let selectChkNum = selectChkNum {
                    if selectChkChar == firstCharUnicode && selectChkNum == 1 && firstCode > 18 {
                        return false
                    }
                    if selectChkChar == lastCharUnicode && selectChkNum == 2 && lastCode <= 18 {
                        return false
                    }
                }
            } else {
                if let chkinrange = item.chkinrange, !chkinrange.contains(counter.first!) {
                    return false
                }
            }

            return true
        }
    }
}
