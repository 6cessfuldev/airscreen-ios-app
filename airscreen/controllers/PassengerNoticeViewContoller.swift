//
//  PassengerNoticeViewContoller.swift
//  airscreen
//
//  Created by 육성민 on 2/17/24.
//

import Foundation
import UIKit
import Alamofire

class PassengerNoticeViewContoller : UIViewController {
    
    @IBOutlet weak var countingLabel: CountingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PassengerNoticeViewContoller - viewDidLoad")
        fetchTodayPassengersCount()
    }
    
    func fetchTodayPassengersCount() {
        let url = "http://apis.data.go.kr/B551177/PassengerNoticeKR/getfPassengerNoticeIKR"
        guard let serviceKey: String = Bundle.main.passengerNoticeApiKey else {return}
        let request: Parameters = [
            "selectdate": 0,
            "type": "json",
            "serviceKey": serviceKey
        ]
        AF.request(url,
                   method: .get,
                   parameters: request,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate()
            .responseDecodable(of: APIResponse<PassengerNoticeList>.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    print("Received TodayPassengersCount: \(apiResponse)")
                    let responseData = apiResponse.response.body.items?.last?.t1sumset2
                    
                    if let stringValue = responseData, let floatValue = Float(stringValue) {
                        self.countingLabel.count(fromValue: 0, to: floatValue, withDuration: 2, andAnimationType: .EaseIn)
                    }
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
        }
    }
    
}
