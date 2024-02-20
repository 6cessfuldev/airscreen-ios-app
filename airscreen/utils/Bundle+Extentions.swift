//
//  Bundle+Extentions.swift
//  airscreen
//
//  Created by 육성민 on 2/20/24.
//

import Foundation

extension Bundle {
    
    var flightInfoListApiKey: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["PassengerFlightsDeOdp"] as? String else {
            print("API KEY를 가져오는데 실패하였습니다.")
            return nil
        }
        return key
    }
    
}
