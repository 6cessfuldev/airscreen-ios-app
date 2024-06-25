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
    
    @IBOutlet weak var typeaheadTableView: UITableView!
    
    @IBAction func searchBtnAction(_ sender: Any) {
        guard let keyword = textField.text else {return}
        getFlightsList(keyword: keyword);
        typeaheadData = []
        typeaheadTableView.reloadData()
        updateTableViewHeight()
    }
    
    var responseData: [FlightItem]?
    var cachedData: [FlightItem]?
    var typeaheadData: [FlightItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchViewController - viewDidLoad")
        
        tableView.dataSource = self
        tableView.delegate = self
        typeaheadTableView.dataSource = self
        typeaheadTableView.delegate = self
        updateTableViewHeight()
        searchBtn.layer.masksToBounds = true
        searchBtn.layer.cornerRadius = 20
        
        retrieveCacheData()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            updateTableViewHeight()
        }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            typeaheadData = cachedData?.filter{(flightItem) -> Bool in
                return flightItem.flightId?.contains(text) ?? false
            }
        }
        typeaheadTableView.reloadData()
        updateTableViewHeight()
    }
    
    func updateTableViewHeight() {
        typeaheadTableView.layoutIfNeeded()
            var frame = typeaheadTableView.frame
            frame.size.height = typeaheadTableView.contentSize.height
        typeaheadTableView.frame = frame
            
            NSLayoutConstraint.activate([
                typeaheadTableView.heightAnchor.constraint(equalToConstant: typeaheadTableView.contentSize.height)
            ])
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === self.tableView {
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
        } else {
            let cell: TypeaheadTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TypeaheadTableViewCell", for: indexPath) as! TypeaheadTableViewCell
            
            if let flight = typeaheadData?[indexPath.row] {
                cell.filghtid.text = flight.flightId
                cell.airline.text = flight.airline
                cell.airport.text = flight.airport
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            return responseData?.count ?? 0
        }
        else {
            print(typeaheadData?.count ?? 0)
            return typeaheadData == nil ? 0 : min(5, typeaheadData!.count)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView === self.tableView {
            return 30
        }
        else {
            return CGFloat.zero
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === self.tableView {
            guard let selectedDatas = self.responseData else { return }
            let selectedData = selectedDatas[indexPath.row]
            
            if let flightInfoViewController = self.storyboard?.instantiateViewController(identifier: "FlightInfoViewController") as? FlightInfoViewController {
                    flightInfoViewController.flightData = selectedData
                    present(flightInfoViewController, animated: true, completion: nil)
                }
        }
        else {
            guard let keyword = textField.text else {return}
            getFlightsList(keyword: keyword)
            typeaheadData = []
            typeaheadTableView.reloadData()
            updateTableViewHeight()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === self.tableView {
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
        else {
            let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: CGFloat.leastNormalMagnitude)))
            headerView.backgroundColor = .black
            return headerView
        }
        
        
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
    
    func retrieveCacheData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let cachedFilePath = documentURL.appendingPathComponent("cachedFlightData_\(currentDate).json")
        
        if let data = try? Data(contentsOf: cachedFilePath) {
            let decodedData = try? JSONDecoder().decode(DepartingFlightsList.self, from: data)
            cachedData = decodedData?.items
        }
    }
}
