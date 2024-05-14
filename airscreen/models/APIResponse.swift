//
//  APIResponse.swift
//  airscreen
//
//  Created by 육성민 on 4/23/24.
//

import Foundation


struct APIResponse<T: Decodable>: Decodable {
    let response: Response<T>
}

struct Response<T: Decodable>: Decodable {
    let header: Header
    let body: T
}

struct Header: Decodable {
    let resultCode: String
    let resultMsg: String
}
