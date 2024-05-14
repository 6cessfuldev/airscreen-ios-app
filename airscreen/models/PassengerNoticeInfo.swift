//
//  PassengerNoticeInfo.swift
//  airscreen
//
//  Created by 육성민 on 4/23/24.
//

import Foundation

struct PassengerNoticeList: Codable {
    let status: Int?
    let items: [PassengerNoticeByTime]?
}

struct PassengerNoticeByTime : Codable {
    let adate: String?
    let atime: String?
    let t1sum1: String?
    let t1sum2: String?
    let t1sum3: String?
    let t1sum4: String?
    let t1sumset1: String?
    let t1sum5: String?
    let t1sum6: String?
    let t1sum7: String?
    let t1sum8: String?
    let t1sumset2: String?
    let t2sum1: String?
    let t2sum2: String?
    let t2sumset1: String?
    let t2sum3: String?
    let t2sum4: String?
    let t2sumset2: String?
}
