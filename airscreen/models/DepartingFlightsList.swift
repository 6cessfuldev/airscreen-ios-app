//
//  ResponseTestCodable.swift
//  airscreen
//
//  Created by 육성민 on 2/20/24.
//

import Foundation

struct DepartingFlightsList: Codable {
    let response: Response
}

struct Response: Codable {
    let header: Header
    let body: Body
}

struct Header: Codable {
    let resultCode: String
    let resultMsg: String
}

struct Body: Codable {
    let numOfRows: Int?
    let pageNo: Int?
    let totalCount: Int?
    let items: [FlightItem]?
}

struct FlightItem: Codable {
    let airline: String?
    let flightId: String?
    let scheduleDateTime: String?
    let estimatedDateTime: String?
    let airport: String?
    let chkinrange: String?
    let gatenumber: String?
    let codeshare: String?
    let masterflightid: String?
    let remark: String?
    let airportCode: String?
    let terminalid: String?
    let typeOfFlight: String?
    let fid: String?
    let fstandposition: String?
}
